//
//  PasswordTextField.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class PasswordTextField: UITextField {
    
    required init() {
        super.init(frame: .zero)
        
        self.borderStyle = .none
        setup()
        setSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (bounds.width - CGFloat(countSymbols() * 15)) / 2, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (bounds.width -  CGFloat(countSymbols() * 15)) / 2, dy: 0)
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
    private func countSymbols() -> Int {
        if let text = self.text {
            return text.count
        }
        return 0
    }
    
    
    private func setup() {
        let textAttributes: [NSAttributedString.Key: Any] = [
                                .foregroundColor: UIColor(rgb: 0x000000),
                                .font: UIFont(name: "gothampro", size: 24)!
                            ]
        self.defaultTextAttributes = textAttributes
        self.isSecureTextEntry = true
    }
    
    
//    private func setupIcon() {
//        let view = UIView()
//        let iconButton = UIButton()
//        iconButton.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        iconButton.tintColor = UIColor(rgb: 0xC0C0C0)
//        iconButton.frame = CGRectMake(0.0, 0.0, 30, 20)
//
//        view.contentMode = UIView.ContentMode.center
//        view.frame = CGRectMake(0.0, 0.0, 30, 20)
//        view.addSubview(iconButton)
//
//        self.clearButtonMode = .whileEditing
//        self.rightViewMode = .unlessEditing
//        self.rightView = view
//        self.isSecureTextEntry = true
//        self.autocorrectionType = .no
//
//        iconButton.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
//    }
    
    private func setSize() {
        self.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(50)
        }
    }
    
    @objc private func clicked(_ sender:UIButton!) {
        sender.setImage(UIImage(systemName: isSecureTextEntry ? "eye.slash.fill" : "eye.fill"), for: .normal)
        isSecureTextEntry = !isSecureTextEntry
    }
}
