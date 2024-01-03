
//
//  ProfileEditViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 24.12.2023.
//

import Foundation

class ProfileEditViewModel {
    var sections: [[ProfileEditCellData]] = []
    
    init() {
        let section1Data = [
            ProfileEditCellData(placeholder: "Имя", text: nil),
            ProfileEditCellData(placeholder: "Фамилия", text: nil),
            ProfileEditCellData(placeholder: "Логин", text: "Алесястар"),
            ProfileEditCellData(placeholder: "Дата рождения", text: nil)
            
        ]
        
        let section2Data = [
            ProfileEditCellData(placeholder: "Номер телефона", text: nil),
            ProfileEditCellData(placeholder: "Почта", text: "nikitina.alesya@gmail.com")
        ]
        
        sections = [section1Data, section2Data]
    }
    
}
