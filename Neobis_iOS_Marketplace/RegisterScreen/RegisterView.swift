//
//  RegisterView.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class RegisterView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    lazy var createLoginTextField = CustomTextField(textValue: "Имя пользователя")
    lazy var createEmailTextField = CustomTextField(textValue: "Почта")
    
    lazy var stackOfTextFields: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(createLoginTextField)
        stack.addArrangedSubview(createEmailTextField)
        stack.spacing = 32
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var nextButton = CustomButton(textValue: "Войти", isPrimary: true)
    
    
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(cartImageView)
        scrollView.addSubview(logoLabel)
        scrollView.addSubview(stackOfTextFields)
        scrollView.addSubview(nextButton)
    }
    
    private func setConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.cartImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.05)
            make.centerX.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.22)
            make.height.equalTo(cartImageView.snp.width)
        }
        self.logoLabel.snp.makeConstraints { make in
            make.top.equalTo(cartImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        self.stackOfTextFields.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        self.nextButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackOfTextFields.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
}
