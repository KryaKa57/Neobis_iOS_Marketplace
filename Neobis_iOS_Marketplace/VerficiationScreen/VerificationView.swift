//
//  VerificationView.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class VerificationView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    
    lazy var  phoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.fill")?
                        .resize(targetSize: CGSize(width: 45, height: 45))
                        .withTintColor(UIColor(rgb: 0xFFFFFF, alpha: 0.5))
        
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(rgb: 0x5458EA)
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var  mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "gothampro-medium", size: 22)
        return label
    }()
    
    lazy var  secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы отправим вам СМС с кодом подтверждения"
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0xC0C0C0)
        label.numberOfLines = 0
        label.font = UIFont(name: "gothampro", size: 18)
        return label
    }()
    
    lazy var  phoneTextField: UITextField = {
        let textField = UITextField()
        let mainAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 22)
            ]
            
        let placeholderString = "0 (000) 000 00 00"
        let attributedString = NSMutableAttributedString(string: placeholderString, attributes: mainAttributes)
            
        attributedString.addAttributes([.foregroundColor: UIColor.black], range: NSRange(location: 2, length: 1))
        attributedString.addAttributes([.foregroundColor: UIColor.black], range: NSRange(location: 6, length: 1))
            
        textField.attributedPlaceholder = attributedString
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var nextButton = CustomButton(textValue: "Далее", isPrimary: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .white
        nextButton.isEnabled = false
        self.addSubview(phoneIconImageView)
        self.addSubview(mainLabel)
        self.addSubview(secondaryLabel)
        self.addSubview(phoneTextField)
        self.addSubview(nextButton)
    }
    
    private func setConstraints() {
        self.phoneIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(systemBounds.width / 5)
        }
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneIconImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(secondaryLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.nextButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
