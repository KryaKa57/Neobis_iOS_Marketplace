//
//  ProfileViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 20.12.2023.
//

import Foundation

class ProfileViewModel {
    var sections: [[ProfileCellData]] = []
    
    var onSucceedRequest: ((UserDetails) -> Void)?
    var onErrorMessage : ((NetworkError) -> Void)?
    
    init() {
        let section1Data = [
            ProfileCellData(imageName: "heart", labelText: "Понравившиеся"),
            ProfileCellData(imageName: "store", labelText: "Мои товары")
        ]
        
        let section2Data = [
            ProfileCellData(imageName: "logout", labelText: "Выйти")
        ]
        
        sections = [section1Data, section2Data]
    }
    
    public func getUser() {
        let endpoint = Endpoint.getUser()
        NetworkManager.postData(data: nil, with: endpoint) { [weak self] (result: Result<UserDetails, NetworkError>) in
            switch result {
            case .success(let res):
                self?.onSucceedRequest?(res)
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}

