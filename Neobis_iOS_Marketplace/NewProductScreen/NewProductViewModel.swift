//
//  NewProductViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation

class NewProductViewModel {
    
    var onProductAdded: (() -> Void)?
    var onErrorMessage: ((NetworkError) -> Void)?
    
    func postData(_ data: Product) {
        let endpoint = Endpoint.addProduct()
        let requestData = try? JSONEncoder().encode(data)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] (result: Result<JWT, NetworkError>) in
            switch result {
            case .success:
                self?.onProductAdded?()
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    var numberOfSections: Int {
        return 4
    }

    var placeholderValues: [String] = ["Цена","Название","Краткое описание","Детальное описание"]
    
}
