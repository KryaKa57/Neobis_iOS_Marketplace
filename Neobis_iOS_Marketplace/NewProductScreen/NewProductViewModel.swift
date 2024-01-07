//
//  NewProductViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit

class NewProductViewModel {
    
    var onProductAdded: (() -> Void)?
    var onErrorMessage: ((NetworkError) -> Void)?
    
    func postData(_ data: [String : Any], _ image: Data) {
//        let endpoint = Endpoint.addProduct()
//        let boundary = "Boundary-\(UUID().uuidString)"
//        //let body = multipartFormDataBody(boundary, "Test", 5, image)
//
//        let body = createFormData(boundary: boundary)
//
//
//        NetworkManager.postData(data: body, with: endpoint) { [weak self] (result: Result<Product, NetworkError>) in
//            switch result {
//            case .success:
//                print("added")
//            case .failure(let error):
//                print(error.localizedDescription)
//                self?.onErrorMessage?(error)
//            }
//        }
    }
    
    private func multipartFormDataBody(_ boundary: String, _ fromName: String, _ intValue: Int, _ image: Data) -> Data {
            let lineBreak = "\r\n"
            var body = Data()
            
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"price\"\(lineBreak + lineBreak)")
            body.append("\(intValue) \(lineBreak)")
        
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"title\"\(lineBreak + lineBreak)")
            body.append("\(fromName + lineBreak)")
        
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"short_description\"\(lineBreak + lineBreak)")
            body.append("\(fromName + lineBreak)")
        
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"description\"\(lineBreak + lineBreak)")
            body.append("\(fromName + lineBreak)")
            
            print(String(data: body, encoding: .utf8) ?? Data())
        
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"product_image\"; filename=\"\(uuid).jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(image)
                body.append(lineBreak)
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            return body
    }
    
    func convertDictionaryToString(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting dictionary to string: \(error)")
            return nil
        }
    }
    
    var numberOfSections: Int {
        return 4
    }

    var placeholderValues: [String] = ["Цена","Название","Краткое описание","Детальное описание"]
    
    
    func sendFormDataWithAlamofire(data: [String : Any], image: Data) {
        
        let endpoint = Endpoint.addProduct()
        
        NetworkManager.postDataWithImage(parameters: data, image: image, with: endpoint)
    }
}


extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

