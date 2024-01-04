//
//  Endpoint.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 02.01.2024.
//

import Foundation

enum Endpoint {
    
    case postLogin(url: String = "/api/v1/auth/login/")
    case postRegistration(url: String = "/api/registration/")
    
    case getUser(url: String = "/api/v1/auth/user/")
    case getProducts(url: String = "/products/")
    
    case addProduct(url: String = "/products/add/")
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(for: self)
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pavel-backender.org.kg"
        components.port = nil
        components.path = self.path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .postRegistration(let url), .postLogin(let url), .getUser(let url), .getProducts(let url)
            , .addProduct(let url):
            return url
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .postRegistration, .postLogin, .addProduct:
            return HTTP.Method.post.rawValue
        case .getUser, .getProducts:
            return HTTP.Method.get.rawValue
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .postRegistration, .postLogin, .getUser, .getProducts:
            let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
            
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.accept.rawValue)
            self.setValue(cookies.first?.value, forHTTPHeaderField: HTTP.Headers.Key.csrfToken.rawValue)
        case .addProduct:
            let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
            
            
            let boundary = "Boundary-\(UUID().uuidString)"
            self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.accept.rawValue)
            self.setValue(cookies.first?.value, forHTTPHeaderField: HTTP.Headers.Key.csrfToken.rawValue)
            
        }
    }
    
    mutating func addBody(for endpoint: Endpoint, with data: Data?) {
        switch endpoint {
        case .postRegistration, .postLogin, .getUser, .getProducts, .addProduct:
            self.httpBody = data
        }
    }
}

