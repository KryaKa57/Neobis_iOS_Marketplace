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
    case getUserProducts(url: String = "/products/my-list/")
    
    case addProduct(url: String = "/products/add/")
    case deleteProduct(url: String = "/products/")
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(for: self)
        return request
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pavel-backender.org.kg"
        components.port = nil
        components.path = self.path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .postRegistration(let url), .postLogin(let url), .getUser(let url), .getProducts(let url), .getUserProducts(let url), .addProduct(let url), .deleteProduct(let url):
            return url
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .postRegistration, .postLogin, .addProduct:
            return HTTP.Method.post.rawValue
        case .getUser, .getProducts, .getUserProducts:
            return HTTP.Method.get.rawValue
        case .deleteProduct:
            return HTTP.Method.delete.rawValue
            
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .postRegistration, .postLogin, .getUser, .getProducts, .getUserProducts, .deleteProduct:
            let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.accept.rawValue)
            self.setValue(cookies.first?.value, forHTTPHeaderField: HTTP.Headers.Key.csrfToken.rawValue)
        case .addProduct:
            let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
            
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.accept.rawValue)
            self.setValue(cookies.first?.value, forHTTPHeaderField: HTTP.Headers.Key.csrfToken.rawValue)
            let boundary = "Boundary-\(UUID().uuidString)"
            self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            
            let token = TokenDataManager.manager.accessToken
            let authorizationHeaderValue = "Bearer \(token)"
            self.setValue(authorizationHeaderValue, forHTTPHeaderField: HTTP.Headers.Key.auth.rawValue)
            
        }
        
    }
}
