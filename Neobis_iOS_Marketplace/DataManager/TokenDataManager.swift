//
//  TokenDataManager.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 02.01.2024.
//

import Foundation

class TokenDataManager {
    static var manager = TokenDataManager()
    
    var accessToken = ""
    var refreshToken = ""
    
    func setAccessToken(token: String) {
        self.accessToken = token
    }
    
    func getAccessToken() -> String {
        return accessToken
    }
    
    func setRefreshToken(token: String) {
        self.refreshToken = token
    }
    
    func getRefreshToken() -> String {
        return refreshToken
    }
}
