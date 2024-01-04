//
//  MainViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 29.12.2023.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

class MainViewModel {
    
    weak var delegate: MainViewModelDelegate?
    
    private var items: [Product] = []
        
    func didSelectItem(at index: Int) {
        delegate?.didSelectItem(at: index)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
        
    func item(at index: Int) -> Product {
        return items[index]
    }
    
    
    var sections: [[ProfileCellData]] = []
    
    
    init() {
        self.getProducts()
    }
    
    public func getProducts() {
        let endpoint = Endpoint.getProducts()
        NetworkManager.postData(data: nil, with: endpoint) { [weak self] (result: Result<[Product], NetworkError>) in
            switch result {
            case .success(let res):
                self?.items = res
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

