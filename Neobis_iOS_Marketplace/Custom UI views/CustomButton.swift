//
//  CustomButton.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 19.12.2023.
//

import Foundation
import UIKit

enum ButtonStyle {
    case primary, secondary
    
    func getTitleColor() -> UIColor {(self == .primary) ? UIColor.white : UIColor(rgb: 0x5458EA)}
    func getBackgroundColor() -> UIColor {self == .primary ? UIColor(rgb: 0x5458EA) : UIColor.white}
    
    func getBackgroundColorDisabled() -> UIColor {(self == .primary) ? UIColor(rgb: 0xD7D7D7) : UIColor(rgb: 0xF6F6F6)}
}

class CustomButton: UIButton {
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 5)
    
    var textValue: String
    var style = ButtonStyle.primary
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = style.getBackgroundColor()
            } else {
                self.backgroundColor = style.getBackgroundColorDisabled()
            }
        }
    }
    
    required init(textValue: String, isPrimary: Bool = true) {
        self.textValue = textValue
        super.init(frame: .zero)
        style = isPrimary ? .primary : .secondary
        setup()
        setSize()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setup() {
        self.setTitle(textValue, for: .normal)
        self.titleLabel?.font = UIFont(name: "gothampro-medium", size: 16)!
        self.setTitleColor(style.getTitleColor(), for: .normal)
        self.backgroundColor = style.getBackgroundColor()
        self.layer.cornerRadius = 24
    }
    
    func setSize(_ height: Int = 50, _ width: Int = 330) {
        self.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
