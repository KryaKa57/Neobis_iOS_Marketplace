//
//  RecoveryViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation

class RecoveryViewModel {
    init() {
    }
    
    public func getCode(from email: String) {
        let endpoint = Endpoint.postCode()
        
        let data = PasswordReset(email: email)
        let requestData = try? JSONEncoder().encode(data)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] (result: Result<RestAuthDetail, NetworkError>) in
            switch result {
            case .success(let res):
                print(res)
                //self?.onSucceedRequest?(res)
            case .failure(let error):
                print(error.localizedDescription)
                //self?.onErrorMessage?(error)
            }
        }
    }
    
}
