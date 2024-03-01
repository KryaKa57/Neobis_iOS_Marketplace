//
//  PopUpManager.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 10.01.2024.
//

import Foundation
import UIKit

enum PopUpStyle {
    case errorOne, errorTwo, success
    
    func getTitleColor() -> UIColor {
        switch (self) {
        case .errorOne: return .red
        case .success, .errorTwo: return .white
        }
    }
    func getBackgroundColor() -> UIColor {
        switch (self) {
        case .errorOne: return .white
        case .errorTwo: return .red
        case .success: return UIColor(rgb: 0x8FC53B)
        }
    }
    func getImageName() -> String {
        switch (self) {
        case .errorOne, .errorTwo: return  "exclamationmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
    func getBorderColor() -> UIColor {
        switch (self) {
        case .errorTwo, .errorOne: return .red
        case .success: return UIColor(rgb: 0x8FC53B)
        }
    }
}

class PopupManager {
    static func showLoginFailurePopUp(on view: UIView, message: String, style: PopUpStyle) {
        let safeAreaTopInset = view.safeAreaInsets.top
        let popUpView = UIView(frame: CGRect(x: 32, y: safeAreaTopInset - 64 , width: view.frame.width - 64, height: 64))
        
        popUpView.layer.borderWidth = 1.0
        popUpView.layer.borderColor = style.getBorderColor().cgColor
        popUpView.layer.cornerRadius = 16
        popUpView.backgroundColor = style.getBackgroundColor()
        
        
        let iconImage = UIImage(systemName: style.getImageName())
        let iconImageView = UIImageView(frame: CGRect(x: 16, y: popUpView.frame.height/2 - 16, width: 32, height: 32))
        iconImageView.image = iconImage
        iconImageView.tintColor = style.getTitleColor()
        
        let messageLabel = UILabel(frame: CGRect(x: 56, y: 0, width: popUpView.frame.width - 56, height: popUpView.frame.height))
        let textAttributes =  [
            NSAttributedString.Key.font: UIFont(name: "gothampro-medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: style.getTitleColor()
            ]
        messageLabel.numberOfLines = 0
        messageLabel.attributedText = NSAttributedString(string: message,
                                                         attributes: textAttributes)
        
        popUpView.addSubview(iconImageView)
        popUpView.addSubview(messageLabel)
        view.addSubview(popUpView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            popUpView.frame.origin.y = safeAreaTopInset
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5, animations: {
                    popUpView.frame.origin.y = safeAreaTopInset - 64
                }, completion: { _ in
                    popUpView.removeFromSuperview()
                })
            }
        })
    }
}
