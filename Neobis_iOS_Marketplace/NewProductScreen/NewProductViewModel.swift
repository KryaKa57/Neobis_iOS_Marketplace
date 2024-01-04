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
    
    func postData(_ data: ProductDetails) {
        let endpoint = Endpoint.addProduct()
        let requestData = try? JSONEncoder().encode(data)
        
        NetworkManager.postData(data: requestData, with: endpoint) { [weak self] (result: Result<Product, NetworkError>) in
            switch result {
            case .success:
                print("added")
            case .failure(let error):
                print(error.localizedDescription)
                self?.onErrorMessage?(error)
            }
        }
    }
    
    var numberOfSections: Int {
        return 4
    }

    var placeholderValues: [String] = ["Цена","Название","Краткое описание","Детальное описание"]
    
}
