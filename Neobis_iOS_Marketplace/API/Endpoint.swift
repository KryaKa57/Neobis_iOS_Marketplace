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
        case .postRegistration(let url), .postLogin(let url):
            return url
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .postRegistration, .postLogin:
            return HTTP.Method.post.rawValue
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .postRegistration, .postLogin:
            let cookies =  URLSession.shared.configuration.httpCookieStorage?.cookies ?? [HTTPCookie()]
            
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.accept.rawValue)
            self.setValue(cookies.first?.value, forHTTPHeaderField: HTTP.Headers.Key.csrfToken.rawValue)
        }
    }
    
    mutating func addBody(for endpoint: Endpoint, with data: Data?) {
        switch endpoint {
        case .postRegistration, .postLogin:
            self.httpBody = data
        }
    }
}

