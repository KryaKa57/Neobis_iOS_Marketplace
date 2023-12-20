//
//  CreatePasswordView.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class CreatePasswordView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(rgb: 0x5458EA)
        imageView.layer.cornerRadius = 20
        
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowColor = UIColor(rgb: 0x5458EA).cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 15)
        
        let image = UIImage(named: "lock")
        imageView.image = image
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var createPasswordLabel: UILabel = {
        let label = UILabel()
        let textAttributes = [
                NSAttributedString.Key.font: UIFont(name: "gothampro-bold", size: 20)!,
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x000000)
                ]
        label.attributedText = NSAttributedString( string: "Придумайте пароль",
                                                   attributes: textAttributes)
        return label
    }()
    
    lazy var requirementsLabel: UILabel = {
        let label = UILabel()
        let textAttributes = [
                NSAttributedString.Key.font: UIFont(name: "gothampro-bold", size: 16)!,
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC0C0C0)
                ]
        label.attributedText = NSAttributedString( string: "Минимальная длина — 8 символов. Для надежности пароль должен                                                       содержать буквы и цифры.", attributes: textAttributes)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstPasswordTextField = PasswordTextField()
    lazy var secondPasswordTextField = PasswordTextField()
    
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(cartImageView)
        scrollView.addSubview(createPasswordLabel)
        scrollView.addSubview(requirementsLabel)
        scrollView.addSubview(firstPasswordTextField)
        scrollView.addSubview(secondPasswordTextField)
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
        self.createPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(cartImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        self.requirementsLabel.snp.makeConstraints { make in
            make.top.equalTo(createPasswordLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        self.firstPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(requirementsLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        self.secondPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(firstPasswordTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        self.nextButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(secondPasswordTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
}

