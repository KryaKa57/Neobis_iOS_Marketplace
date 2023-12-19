//
//  LoginView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 19.12.2023.
//

import Foundation
import UIKit
import SnapKit

class LoginView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shopping-cart")
        return imageView
    }()
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        let textAttributes = [
                NSAttributedString.Key.font: UIFont(name: "gothampro-bold", size: 18)!,
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000)
                ]
        label.attributedText = NSAttributedString( string: "MOBI MARKET",
                                                   attributes: textAttributes)
        label.numberOfLines = 3
        return label
    }()
    
    lazy var loginTextField = CustomTextField(textValue: "Имя пользователя")
    lazy var passwordTextField = CustomTextField(textValue: "Пароль", isHidden: true)
    lazy var enterButton = CustomButton(textValue: "Войти")
    lazy var registerButton = CustomButton(textValue: "Зарегистрироваться", isPrimary: false)
    
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
        enterButton.isEnabled = false
        
        addSubview(cartImageView)
        addSubview(logoLabel)
        addSubview(loginTextField)
        addSubview(passwordTextField)
        addSubview(enterButton)
        addSubview(registerButton)
    }
    
    private func setConstraints() {
        self.cartImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.1)
            make.centerX.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.22)
            make.height.equalTo(cartImageView.snp.width)
        }
        self.logoLabel.snp.makeConstraints { make in
            make.top.equalTo(cartImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(enterButton).offset(32)
        }
        self.loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(systemBounds.height * 0.1)
            make.centerX.equalToSuperview()
        }
        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        self.enterButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        self.registerButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(enterButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(systemBounds.height * 0.1)
            make.centerX.equalToSuperview()
        }
    }
}
