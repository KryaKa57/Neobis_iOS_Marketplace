//
//  RegisterService.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 02.01.2024.
//

import Foundation
import Alamofire

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown(String = "An unknown error occured.")
}

class NetworkManager {
    static func postData<T: Decodable> (data: Data?,
                         with endpoint: Endpoint,
                         completition: @escaping (Result<T, NetworkError>)->Void) {
        let delegate = APIRequestDelegate
        var request = endpoint.request!
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) {data, resp, error in
            if let error = error {
                completition(.failure(.unknown(error.localizedDescription)))
                return
            }

            if let resp = resp as? HTTPURLResponse, resp.statusCode < 200 && resp.statusCode >= 300 {
                completition(.failure(.invalidResponse))
                return
            }
            
            do {
                if try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) is [String: Any] {
              } else {
                print("data maybe corrupted or in wrong format")
                throw URLError(.badServerResponse)
              }
            } catch let error {
              print(error.localizedDescription)
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? Data())
                do {
                    let decoder = JSONDecoder()
                    let tokenKey = try decoder.decode(T.self, from: data)
                    completition(.success(tokenKey))
                } catch {
                    completition(.failure(.invalidData))
                }
            } else {
                completition(.failure(.unknown()))
            }
        }.resume()
    }
    
    static func postDataWithImage (parameters: [String: Any],
                                   image: Data,
                                   with endpoint: Endpoint) {
        
        let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
        let token = TokenDataManager.manager.accessToken
        let authorizationHeaderValue = "Bearer \(token)"
        
        AF.upload (
            multipartFormData: { (multipartFormData: MultipartFormData) in
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else if let intValue = value as? Int {
                        let stringValue = "\(intValue)"
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    }
                }

                multipartFormData.append(image, withName: "product_image", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: endpoint.url!,
            method: .post,
            headers: [
                HTTP.Headers.Key.contentType.rawValue: "multipart/form-data",
                HTTP.Headers.Key.accept.rawValue: HTTP.Headers.Value.applicationJson.rawValue,
                HTTP.Headers.Key.csrfToken.rawValue: cookies.first?.value ?? "",
                HTTP.Headers.Key.auth.rawValue: authorizationHeaderValue
            ]
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                delegate
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
