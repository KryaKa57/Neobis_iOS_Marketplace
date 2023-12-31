//
//  CLDNSessionManager.swift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Responsible for creating and managing `CLDNRequest` objects, as well as their underlying `NSURLSession`.
internal class CLDNSessionManager {

    // MARK: - Helper Types

    /// Defines whether the `CLDNMultipartFormData` encoding was successful and contains result of the encoding as
    /// associated values.
    ///
    /// - Success: Represents a successful `CLDNMultipartFormData` encoding and contains the new `CLDNUploadRequest` along with
    ///            streaming information.
    /// - Failure: Used to represent a failure in the `CLDNMultipartFormData` encoding and also contains the encoding
    ///            error.
    internal enum MultipartFormDataEncodingResult {
        case success(request: CLDNUploadRequest, streamingFromDisk: Bool, streamFileURL: URL?)
        case failure(Error)
    }

    // MARK: - Properties

    /// A default instance of `SessionManager`, used by top-level Cloudinary request methods, and suitable for use
    /// directly for any ad hoc requests.
    internal static let `default`: CLDNSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = CLDNSessionManager.defaultHTTPHeaders

        return CLDNSessionManager(configuration: configuration)
    }()

    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    internal static let defaultHTTPHeaders: CLDNHTTPHeaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"

        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")

        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.cloudinary.iOS-Example; build:1; iOS 10.0.0) cloudinary/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                let cloudinaryVersion: String = {
                    guard
                        let afInfo = Bundle(for: CLDNSessionManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                    else { return "Unknown" }

                    return "Cloudinary/\(build)"
                }()

                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(cloudinaryVersion)"
            }

            return "Cloudinary"
        }()

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    /// Default memory threshold used when encoding `MultipartFormData` in bytes.
    internal static let multipartFormDataEncodingMemoryThreshold: UInt64 = 10_000_000

    /// The underlying session.
    internal let session: URLSession

    /// The session delegate handling all the task and session delegate callbacks.
    internal let delegate: CLDNSessionDelegate

    /// Whether to start requests immediately after being constructed. `true` by default.
    internal var startRequestsImmediately: Bool = true

    /// The request adapter called each time a new request is created.
    internal var adapter: CLDNRequestAdapter?

    /// The request retrier called each time a request encounters an error to determine whether to retry the request.
    internal var retrier: CLDNRequestRetrier? {
        get { return delegate.retrier }
        set { delegate.retrier = newValue }
    }

    /// The background completion handler closure provided by the UIApplicationDelegate
    /// `application:handleEventsForBackgroundURLSession:completionHandler:` method. By setting the background
    /// completion handler, the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` closure implementation
    /// will automatically call the handler.
    ///
    /// If you need to handle your own events before the handler is called, then you need to override the
    /// SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` and manually call the handler when finished.
    ///
    /// `nil` by default.
    internal var backgroundCompletionHandler: (() -> Void)?

    let queue = DispatchQueue(label: "com.cloudinary.session-manager." + UUID().uuidString)

    // MARK: - Lifecycle

    /// Creates an instance with the specified `configuration`, `delegate` and `serverTrustPolicyManager`.
    ///
    /// - parameter configuration:            The configuration used to construct the managed session.
    ///                                       `URLSessionConfiguration.default` by default.
    /// - parameter delegate:                 The delegate used when initializing the session. `CLDNSessionDelegate()` by
    ///                                       default.
    /// - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ///                                       challenges. `nil` by default.
    ///
    /// - returns: The new `CLDNSessionManager` instance.
    internal init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: CLDNSessionDelegate = CLDNSessionDelegate())
    {
        configuration.urlCredentialStorage = nil;
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)

        commonInit()
    }

    /// Creates an instance with the specified `session`, `delegate` and `serverTrustPolicyManager`.
    ///
    /// - parameter session:                  The URL session.
    /// - parameter delegate:                 The delegate of the URL session. Must equal the URL session's delegate.
    /// - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ///                                       challenges. `nil` by default.
    ///
    /// - returns: The new `CLDNSessionManager` instance if the URL session's delegate matches; `nil` otherwise.
    internal init?(
        session: URLSession,
        delegate: CLDNSessionDelegate)
    {
        guard delegate === session.delegate else { return nil }

        self.delegate = delegate
        self.session = session

        commonInit()
    }

    private func commonInit() {

        delegate.sessionManager = self

        delegate.sessionDidFinishEventsForBackgroundURLSession = { [weak self] session in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.backgroundCompletionHandler?() }
        }
    }

    deinit {
        session.invalidateAndCancel()
    }

    // MARK: - Data Request

    /// Creates a `CLDNDataRequest` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding`
    /// and `headers`.
    ///
    /// - parameter url:        The URL.
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter encoding:   The parameter encoding. `CLDNURLEncoding.default` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `CLDNDataRequest`.
    @discardableResult
    internal func request(
        _ url: CLDNURLConvertible,
        method: CLDNHTTPMethod = .get,
        parameters: CLDNParameters? = nil,
        encoding: CLDNParameterEncoding = CLDNURLEncoding.default,
        headers: CLDNHTTPHeaders? = nil)
        -> CLDNDataRequest
    {
        var originalRequest: URLRequest?

        do {
            var parameters = parameters
            let timeoutParamater = parameters?.removeValue(forKey: CLDConfiguration.ConfigParam.Timeout.description)
            
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            var encodedURLRequest = try encoding.CLDN_Encode(originalRequest!, with: parameters)
            
            if let timeout = timeoutParamater as? NSNumber {
                encodedURLRequest.timeoutInterval = timeout.doubleValue
            }
            
            return request(encodedURLRequest)
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    /// Creates a `CLDNDataRequest` to retrieve the contents of a URL based on the specified `urlRequest`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `CLDNDataRequest`.
    @discardableResult
    internal func request(_ urlRequest: CLDNURLRequestConvertible) -> CLDNDataRequest {
        var originalRequest: URLRequest?

        do {
            originalRequest = try urlRequest.CLDN_AsURLRequest()
            let originalTask = CLDNDataRequest.Requestable(urlRequest: originalRequest!)

            let task = try originalTask.CLDN_Task(session: session, adapter: adapter, queue: queue)
            let request = CLDNDataRequest(session: session, requestTask: .data(originalTask, task))

            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    // MARK: Private - Request Implementation

    private func request(_ urlRequest: URLRequest?, failedWith error: Error) -> CLDNDataRequest {
        var requestTask: CLDNRequest.RequestTask = .data(nil, nil)

        if let urlRequest = urlRequest {
            let originalTask = CLDNDataRequest.Requestable(urlRequest: urlRequest)
            requestTask = .data(originalTask, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error
        let request = CLDNDataRequest(session: session, requestTask: requestTask, error: underlyingError)

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: request, with: underlyingError)
        } else {
            if startRequestsImmediately { request.resume() }
        }

        return request
    }

    // MARK: - Upload Request

    // MARK: File

    /// Creates an `CLDNUploadRequest` from the specified `url`, `method` and `headers` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:    The file to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(
        _ fileURL: URL,
        to url: CLDNURLConvertible,
        method: CLDNHTTPMethod = .post,
        headers: CLDNHTTPHeaders? = nil)
        -> CLDNUploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(fileURL, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates a `CLDNUploadRequest` from the specified `urlRequest` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:       The file to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(_ fileURL: URL, with urlRequest: CLDNURLRequestConvertible) -> CLDNUploadRequest {
        do {
            let urlRequest = try urlRequest.CLDN_AsURLRequest()
            return upload(.file(fileURL, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: Data

    /// Creates an `CLDNUploadRequest` from the specified `url`, `method` and `headers` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:    The data to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(
        _ data: Data,
        to url: CLDNURLConvertible,
        method: CLDNHTTPMethod = .post,
        headers: CLDNHTTPHeaders? = nil)
        -> CLDNUploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(data, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates an `CLDNUploadRequest` from the specified `urlRequest` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:       The data to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(_ data: Data, with urlRequest: CLDNURLRequestConvertible) -> CLDNUploadRequest {
        do {
            let urlRequest = try urlRequest.CLDN_AsURLRequest()
            return upload(.data(data, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: InputStream

    /// Creates an `CLDNUploadRequest` from the specified `url`, `method` and `headers` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:  The stream to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(
        _ stream: InputStream,
        to url: CLDNURLConvertible,
        method: CLDNHTTPMethod = .post,
        headers: CLDNHTTPHeaders? = nil)
        -> CLDNUploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(stream, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates an `CLDNUploadRequest` from the specified `urlRequest` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:     The stream to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `CLDNUploadRequest`.
    @discardableResult
    internal func upload(_ stream: InputStream, with urlRequest: CLDNURLRequestConvertible) -> CLDNUploadRequest {
        do {
            let urlRequest = try urlRequest.CLDN_AsURLRequest()
            return upload(.stream(stream, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: CLDNMultipartFormData

    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `CLDNUploadRequest` using the `url`, `method` and `headers`.
    ///
    /// It is important to understand the memory implications of uploading `CLDNMultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Cloudinary to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `CLDNMultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `CLDNMultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter url:                     The URL.
    /// - parameter method:                  The HTTP method. `.post` by default.
    /// - parameter headers:                 The HTTP headers. `nil` by default.
    /// - parameter encodingCompletion:      The closure called when the `CLDNMultipartFormData` encoding is complete.
    internal func upload(
        multipartFormData: @escaping (CLDNMultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = CLDNSessionManager.multipartFormDataEncodingMemoryThreshold,
        to url: CLDNURLConvertible,
        method: CLDNHTTPMethod = .post,
        headers: CLDNHTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        timeout: NSNumber? = nil,
        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            if let timeout = timeout {
                urlRequest.timeoutInterval = timeout.doubleValue
            }
            return upload(
                multipartFormData: multipartFormData,
                usingThreshold: encodingMemoryThreshold,
                with: urlRequest,
                queue: queue,
                encodingCompletion: encodingCompletion
            )
        } catch {
            (queue ?? DispatchQueue.main).async { encodingCompletion?(.failure(error)) }
        }
    }

    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `CLDNUploadRequest` using the `urlRequest`.
    ///
    /// It is important to understand the memory implications of uploading `CLDNMultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Cloudinary to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `CLDNMultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `CLDNMultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter urlRequest:              The URL request.
    /// - parameter encodingCompletion:      The closure called when the `CLDNMultipartFormData` encoding is complete.
    internal func upload(
        multipartFormData: @escaping (CLDNMultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = CLDNSessionManager.multipartFormDataEncodingMemoryThreshold,
        with urlRequest: CLDNURLRequestConvertible,
        queue: DispatchQueue? = nil,
        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
    {
        DispatchQueue.global(qos: .utility).async {
            let formData = CLDNMultipartFormData()
            multipartFormData(formData)

            var tempFileURL: URL?

            do {
                var urlRequestWithContentType = try urlRequest.CLDN_AsURLRequest()
                urlRequestWithContentType.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")

                let isBackgroundSession = self.session.configuration.identifier != nil

                if formData.contentLength < encodingMemoryThreshold && !isBackgroundSession {
                    let data = try formData.encode()

                    let encodingResult = MultipartFormDataEncodingResult.success(
                        request: self.upload(data, with: urlRequestWithContentType),
                        streamingFromDisk: false,
                        streamFileURL: nil
                    )

                    (queue ?? DispatchQueue.main).async { encodingCompletion?(encodingResult) }
                } else {
                    let fileManager = FileManager.default
                    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    let directoryURL = tempDirectoryURL.appendingPathComponent("org.cloudinary.manager/multipart.form.data")
                    let fileName = UUID().uuidString
                    let fileURL = directoryURL.appendingPathComponent(fileName)

                    tempFileURL = fileURL

                    var directoryError: Error?

                    // Create directory inside serial queue to ensure two threads don't do this in parallel
                    self.queue.sync {
                        do {
                            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            directoryError = error
                        }
                    }

                    if let directoryError = directoryError { throw directoryError }

                    try formData.writeEncodedData(to: fileURL)

                    let upload = self.upload(fileURL, with: urlRequestWithContentType)

                    // Cleanup the temp file once the upload is complete
                    upload.delegate.queue.addOperation {
                        do {
                            try FileManager.default.removeItem(at: fileURL)
                        } catch {
                            // No-op
                        }
                    }

                    (queue ?? DispatchQueue.main).async {
                        let encodingResult = MultipartFormDataEncodingResult.success(
                            request: upload,
                            streamingFromDisk: true,
                            streamFileURL: fileURL
                        )

                        encodingCompletion?(encodingResult)
                    }
                }
            } catch {
                // Cleanup the temp file in the event that the multipart form data encoding failed
                if let tempFileURL = tempFileURL {
                    do {
                        try FileManager.default.removeItem(at: tempFileURL)
                    } catch {
                        // No-op
                    }
                }

                (queue ?? DispatchQueue.main).async { encodingCompletion?(.failure(error)) }
            }
        }
    }

    // MARK: Private - Upload Implementation

    private func upload(_ uploadable: CLDNUploadRequest.Uploadable) -> CLDNUploadRequest {
        do {
            let task = try uploadable.CLDN_Task(session: session, adapter: adapter, queue: queue)
            let upload = CLDNUploadRequest(session: session, requestTask: .upload(uploadable, task))

            if case let .stream(inputStream, _) = uploadable {
                upload.delegate.taskNeedNewBodyStream = { _, _ in inputStream }
            }

            delegate[task] = upload

            if startRequestsImmediately { upload.resume() }

            return upload
        } catch {
            return upload(uploadable, failedWith: error)
        }
    }

    private func upload(_ uploadable: CLDNUploadRequest.Uploadable?, failedWith error: Error) -> CLDNUploadRequest {
        var uploadTask: CLDNRequest.RequestTask = .upload(nil, nil)

        if let uploadable = uploadable {
            uploadTask = .upload(uploadable, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error
        let upload = CLDNUploadRequest(session: session, requestTask: uploadTask, error: underlyingError)

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: upload, with: underlyingError)
        } else {
            if startRequestsImmediately { upload.resume() }
        }

        return upload
    }

    // MARK: - Internal - Retry Request

    func retry(_ request: CLDNRequest) -> Bool {
        guard let originalTask = request.originalTask else { return false }

        do {
            let task = try originalTask.CLDN_Task(session: session, adapter: adapter, queue: queue)

            if let originalTask = request.task {
                delegate[originalTask] = nil // removes the old request to avoid endless growth
            }

            request.delegate.task = task // resets all task delegate data

            request.retryCount += 1
            request.startTime = CFAbsoluteTimeGetCurrent()
            request.endTime = nil

            task.resume()

            return true
        } catch {
            request.delegate.error = error.underlyingAdaptError ?? error
            return false
        }
    }

    private func allowRetrier(_ retrier: CLDNRequestRetrier, toRetry request: CLDNRequest, with error: Error) {
        DispatchQueue.CLDNUtility.async { [weak self] in
            guard let strongSelf = self else { return }

            retrier.CLDN_Should(strongSelf, retry: request, with: error) { shouldRetry, timeDelay in
                guard let strongSelf = self else { return }

                guard shouldRetry else {
                    if strongSelf.startRequestsImmediately { request.resume() }
                    return
                }

                DispatchQueue.CLDNUtility.CLDN_after(timeDelay) {
                    guard let strongSelf = self else { return }

                    let retrySucceeded = strongSelf.retry(request)

                    if retrySucceeded, let task = request.task {
                        strongSelf.delegate[task] = request
                    } else {
                        if strongSelf.startRequestsImmediately { request.resume() }
                    }
                }
            }
        }
    }
}
