//
//  LoginViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 19.12.2023.
//

import Foundation

class LoginViewModel {
    var onUserLogined: (() -> Void)?
    var onErrorMessage: ((NetworkError) -> Void)?
    
    func postData(_ data: Login) {
        let endpoint = Endpoint.postLogin()
        let requestData = try? JSONEncoder().encode(data)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] (result: Result<JWT, NetworkError>) in
            switch result {
            case .success(let res):
                print(res)
                self?.onUserLogined?()
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}


