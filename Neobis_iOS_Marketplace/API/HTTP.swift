//
//  HTTP.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 02.01.2024.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
    
    enum Headers {
        enum Key: String {
            case contentType = "Content-Type"
            case accept = "Accept"
            case csrfToken = "X-CSRFtoken"
            case auth = "Authorization"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
        }
    }
}
