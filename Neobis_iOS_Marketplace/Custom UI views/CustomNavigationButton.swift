//
//  CustomNavigationButton.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 24.12.2023.
//

import Foundation
import UIKit

class CustomNavigationButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
        
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setup() {
        self.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(rgb: 0xC0C0C0, alpha: 0.2)
        
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}
