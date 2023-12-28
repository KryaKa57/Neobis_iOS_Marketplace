//
//  ProfileViewModel.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 20.12.2023.
//

import Foundation

class VerificationViewModel {
    var sections: [[ProfileCellData]] = []
    
    init() {
        // Define data for sections and cells
        let section1Data = [
            ProfileCellData(imageName: "heart", labelText: "Понравившиеся"),
            ProfileCellData(imageName: "store", labelText: "Мои товары")
        ]
        
        let section2Data = [
            ProfileCellData(imageName: "logout", labelText: "Выйти")
        ]
        
        sections = [section1Data, section2Data]
    }
    
    
}
