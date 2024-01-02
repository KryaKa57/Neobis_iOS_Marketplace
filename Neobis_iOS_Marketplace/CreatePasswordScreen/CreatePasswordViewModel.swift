//
//  CreatePasswordViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 20.12.2023.
//

import Foundation

class CreatePasswordViewModel {
    var onUserRegistered: (() -> Void)?
    var onErrorMessage : ((NetworkError) -> Void)?
    
    public func postData(data registerData: Register) {
        let endpoint = Endpoint.postRegistration()
        let requestData = try? JSONEncoder().encode(registerData)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] result in
            switch result {
            case .success(let res):
                TokenDataManager.manager.setAccessToken(token: res.access_token)
                TokenDataManager.manager.setRefreshToken(token: res.refresh_token)
                self?.onUserRegistered?()
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}
