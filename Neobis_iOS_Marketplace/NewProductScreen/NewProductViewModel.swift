//
//  NewProductViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit

import Alamofire

class NewProductViewModel {
    weak var delegate: APIRequestDelegate?
    
    var onProductAdded: (() -> Void)?
    var onErrorMessage: ((NetworkError) -> Void)?
    var result: Product? = nil
    
    var numberOfSections: Int {
        return 4
    }

    var placeholderValues: [String] = ["Цена","Название","Краткое описание","Детальное описание"]
    
    
    func sendFormDataWithAlamofire(data: [String : Any], image: Data, method: Bool, at index: Int = 0) {
        
        let endpoint = method ? Endpoint.deleteProduct(url: "/products/\(index)/") : Endpoint.addProduct()
        var httpMethod = method ? HTTPMethod.patch : HTTPMethod.post
        
        NetworkManager.postDataWithImage(parameters: data, image: image, with: endpoint, method: httpMethod)  { [weak self] (result: Result<Product, AFError>) in
            switch result {
            case .success(let res):
                self?.result = res
                self?.delegate?.onSucceedRequest()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

