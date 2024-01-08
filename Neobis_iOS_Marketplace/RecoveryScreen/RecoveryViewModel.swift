//
//  RecoveryViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation

class RecoveryViewModel {
    var delegate: APIRequestDelegate?
    
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
    
    public func checkCode(from phoneNumber: String, with key: String) {
        let endpoint = Endpoint.checkCode()
        let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let data = VerfiyEmail(phone_number: cleanedPhoneNumber, verification_code: key)
        let requestData = try? JSONEncoder().encode(data)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] (result: Result<RestAuthDetail, NetworkError>) in
            switch result {
            case .success(let res):
                self?.delegate?.onSucceedRequest()
            case .failure(let error):
                print(error.localizedDescription)
                //self?.onErrorMessage?(error)
            }
        }
    }
}
