//
//  Extension + UIColor.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 19.12.2023.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    public convenience init(rgb: Int, alpha: Double = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
}
