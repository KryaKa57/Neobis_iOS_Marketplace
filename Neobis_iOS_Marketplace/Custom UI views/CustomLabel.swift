//
//  CustomLabel.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit

enum LabelStatus {
    case normal, correct, error
    
    func getTextColor() -> UIColor {
        if self == .normal { return UIColor(rgb: 0x767676) }
        else if self == .correct { return UIColor(rgb: 0x1BA228) }
        else { return UIColor(rgb: 0xEC0000) }
    }
    
    func additionallyIcon() -> String {
        if self == .correct { return " \u{2705}" }
        else if self == .error { return " \u{274C}" }
        else { return "" }
    }
}


class CustomLabel: UILabel {
    var textValue: String
    var style = LabelStatus.normal {
        didSet {
            self.text = self.textValue + style.additionallyIcon()
            self.textColor = style.getTextColor()
        }
    }
    
    required init(textValue: String, isOne: Bool = false) {
        let bulletPoint: String = "  \u{2022}  "
        self.textValue = (isOne ? "" : bulletPoint) + textValue
        super.init(frame: .zero)
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setup() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "gothampro", size: 12)!]
        self.attributedText = NSAttributedString(string: textValue, attributes: attributes)
        self.textColor = style.getTextColor()
    }
}
