//
//  CustomTextField.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    private let underlineLayer = CALayer()
    private var textValue: String
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                underlineLayer.backgroundColor = UIColor.black.cgColor
            } else {
                underlineLayer.backgroundColor = UIColor(rgb: 0xC0C0C0).cgColor
            }
        }
    }
    
    required init(textValue: String, isHidden: Bool = false) {
        self.textValue = textValue
        
        super.init(frame: .zero)
        
        self.borderStyle = .none
        CustomTextField.appearance().tintColor = .black
        setup(isHidden: isHidden)
        setSize()
        setupUnderline()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = UIColor(rgb: 0x767676)
            }
        }
        
        
        underlineLayer.frame = CGRect(x: 0, y: frame.height - underlineLayer.frame.height, width: frame.width, height: underlineLayer.frame.height)
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
    
    private func setup(isHidden: Bool) {
        let textAttributes: [NSAttributedString.Key: Any] = [
                                .foregroundColor: UIColor(rgb: 0x000000),
                                .font: UIFont(name: "gothampro", size: 16)!
                            ]
        
        let placholderTextAttributes: [NSAttributedString.Key: Any] = [
                                .foregroundColor: UIColor(rgb: 0xC0C0C0),
                                .font: UIFont(name: "gothampro", size: 16)!
                            ]
        self.attributedPlaceholder = NSAttributedString(string: textValue, attributes: placholderTextAttributes)
        self.defaultTextAttributes = textAttributes
        
        if isHidden {
            setupIcon()
        }
    }
    
    private func setupUnderline() {
        let underlineHeight: CGFloat = 1.0
        underlineLayer.frame = CGRect(x: 0, y: frame.height - underlineHeight, width: frame.width, height: underlineHeight)
        underlineLayer.backgroundColor = UIColor(rgb: 0xC0C0C0).cgColor
        layer.addSublayer(underlineLayer)
    }
    
    private func setupIcon() {
        let view = UIView()
        let iconButton = UIButton()
        iconButton.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        iconButton.tintColor = UIColor(rgb: 0xC0C0C0)
        iconButton.frame = CGRectMake(0.0, 0.0, 30, 20)
    
        view.contentMode = UIView.ContentMode.center
        view.frame = CGRectMake(0.0, 0.0, 30, 20)
        view.addSubview(iconButton)
            
        self.clearButtonMode = .whileEditing
        self.rightViewMode = .unlessEditing
        self.rightView = view
        self.isSecureTextEntry = true
        self.autocorrectionType = .no
            
        iconButton.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
    }
    
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
