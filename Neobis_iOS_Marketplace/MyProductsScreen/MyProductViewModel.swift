//
//  MyProductViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 05.01.2024.
//

import Foundation

protocol APIRequestDelegate: AnyObject {
    func onSucceedRequest()
}

class MyProductViewModel {
    weak var delegate: MainViewModelDelegate?
    weak var delegateRequest: APIRequestDelegate?
    
    private var items: [Product] = []
    var selectedIndex: Int = 0
        
    func didSelectItem(at index: Int) {
        delegate?.didSelectItem(at: index)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
        
    func item(at index: Int) -> Product {
        selectedIndex = index
        return items[index]
    }
    
    init() {
        self.getProducts()
    }
    
    public func getProducts() {
        let endpoint = Endpoint.getUserProducts()
        NetworkManager.postData(data: nil, with: endpoint) { [weak self] (result: Result<[Product], NetworkError>) in
            switch result {
            case .success(let res):
                self?.items = res
                self?.delegateRequest?.onSucceedRequest()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func deleteProduct(product: Product) {
        let endpoint = Endpoint.deleteProduct(url: "/products/\(product.id)/")
        
        NetworkManager.postData(data: nil, with: endpoint) { [weak self] (result: Result<Product, NetworkError>) in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

