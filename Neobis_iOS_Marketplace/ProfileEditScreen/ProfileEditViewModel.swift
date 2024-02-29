
//
//  ProfileEditViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 24.12.2023.
//

import Foundation
import Alamofire

protocol PutRequestDelegate: AnyObject {
    func onSucceedPutRequest()
}


class ProfileEditViewModel {
    var sections: [[ProfileEditCellData]] = []
    var user: CustomUserDetails? = nil
    
    weak var delegateRequest: APIRequestDelegate?
    weak var putRequest: PutRequestDelegate?
    
    init() {
        self.getProfile()
        
        let section1Data = [
            ProfileEditCellData(placeholder: "Имя", text: nil),
            ProfileEditCellData(placeholder: "Фамилия", text: nil),
            ProfileEditCellData(placeholder: "Логин", text: nil),
            ProfileEditCellData(placeholder: "Дата рождения", text: nil)
        ]
        
        let section2Data = [
            ProfileEditCellData(placeholder: "Номер телефона", text: nil),
            ProfileEditCellData(placeholder: "Почта", text: nil)
        ]
        
        sections = [section1Data, section2Data]
    }
    
    public func getProfile() {
        let endpoint = Endpoint.getProfile()
        NetworkManager.postData(data: nil, with: endpoint) { [weak self] (result: Result<CustomUserDetails, NetworkError>) in
            switch result {
            case .success(let res):
                self?.user = res
                self?.delegateRequest?.onSucceedRequest()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func updateSections() {
        let userData = [[user?.first_name, user?.last_name, user?.username, user?.DOB],[user?.phone_number, user?.email]]
        for section in 0..<sections.count {
            for cell in 0..<sections[section].count {
                sections[section][cell].text = userData[section][cell]
            }
        }
    }
    
    func sendFormDataWithAlamofire(data: [String : Any], image: Data, method: HTTPMethod) {
        let endpoint = Endpoint.putProfile()
        NetworkManager.postDataWithImage(parameters: data, image: image, with: endpoint, method: HTTPMethod.put)  { [weak self] (result: Result<CustomUserDetails, AFError>) in
            switch result {
            case .success(_):
                self?.putRequest?.onSucceedPutRequest()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
