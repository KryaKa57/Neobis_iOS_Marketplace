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
    
    lazy var emailTextField = CustomTextField(textValue: "Введите адрес почты")
    lazy var incorrectFormatEmailLabel = CustomLabel(textValue: "Неверный формат адреса почты", isOne: true)
    
    
    lazy var createLoginTextField = CustomTextField(textValue: "Придумайте логин")
    lazy var createPassTextField = CustomTextField(textValue: "Создайте пароль", isHidden: true)
    
    lazy var emailStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(emailTextField)
        stack.spacing = 8
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    lazy var stackOfTextFields: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(createLoginTextField)
        stack.addArrangedSubview(createPassTextField)
        stack.spacing = 16
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var countSymbolLabel = CustomLabel(textValue: "От 8 до 15 символов")
    lazy var hasUpperAndLowerLabel = CustomLabel(textValue: "Строчные и прописные буквы")
    lazy var hasDigitLabel = CustomLabel(textValue: "Минимум 1 цифра")
    lazy var hasSpecificSymbolLabel = CustomLabel(textValue: "Минимум 1 спецсимвол (!, \", #, $...)")
    
    lazy var hintsStackElements: [CustomLabel] = [countSymbolLabel, hasUpperAndLowerLabel, hasDigitLabel, hasSpecificSymbolLabel]
    lazy var allTextFields: [CustomTextField] = [emailTextField, createLoginTextField, createPassTextField, checkPasswordTextField]
    
    lazy var hintsStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(countSymbolLabel)
        stack.addArrangedSubview(hasUpperAndLowerLabel)
        stack.addArrangedSubview(hasDigitLabel)
        stack.addArrangedSubview(hasSpecificSymbolLabel)
        stack.spacing = 8
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    lazy var checkPasswordTextField = CustomTextField(textValue: "Повторите пароль", isHidden: true)
    lazy var differentPassLabel = CustomLabel(textValue: "Пароли не совпадают", isOne: true)
    
    var emailHeightConstraint: Constraint!
    var checkPasswordHeightConstraint: Constraint!
    var bottomButtonConstraint: Constraint!
    
    lazy var checkPasswordStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(checkPasswordTextField)
        stack.spacing = 8
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
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
        differentPassLabel.style = .error
        incorrectFormatEmailLabel.style = .error
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(cartImageView)
        scrollView.addSubview(logoLabel)
        scrollView.addSubview(emailStackView)
        scrollView.addSubview(stackOfTextFields)
        scrollView.addSubview(hintsStackView)
        scrollView.addSubview(checkPasswordStackView)
        scrollView.addSubview(nextButton)
    }
    
    private func setConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            bottomButtonConstraint = make.bottom.equalToSuperview().constraint
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
        
        self.emailStackView.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            emailHeightConstraint = make.height.equalTo(emailTextField.snp.height).constraint
        }
        self.stackOfTextFields.snp.makeConstraints { make in
            make.top.equalTo(emailStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        self.hintsStackView.snp.makeConstraints { make in
            make.top.equalTo(stackOfTextFields.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(32)
            make.width.equalTo(systemBounds.width - 64)
        }
        self.checkPasswordStackView.snp.makeConstraints { make in
            make.top.equalTo(hintsStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            checkPasswordHeightConstraint = make.height.equalTo(checkPasswordTextField.snp.height).constraint
        }
        self.nextButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordStackView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(32)
        }
    }
    
    public func displayKeyBoard(_ keyBoardHeight: CGFloat, isDisplay: Bool) {
        bottomButtonConstraint.deactivate()
        if isDisplay {
            self.scrollView.snp.makeConstraints { make in
                bottomButtonConstraint.update(inset: keyBoardHeight)
            }
        } else {
            self.scrollView.snp.makeConstraints { make in
                bottomButtonConstraint = make.bottom.lessThanOrEqualToSuperview().inset(32).constraint
            }
        }
    }
    
    public func displayTextFieldError(textField: UITextField) {
        if textField == checkPasswordTextField {
            checkPasswordStackView.addArrangedSubview(differentPassLabel)
            checkPasswordHeightConstraint.deactivate()
        } else {
            emailHeightConstraint.deactivate()
            emailStackView.addArrangedSubview(incorrectFormatEmailLabel)
        }
    }

    public func removeTextFieldError(textField: UITextField) {
        if textField == checkPasswordTextField {
            checkPasswordStackView.removeArrangedSubview(differentPassLabel)
            differentPassLabel.removeFromSuperview()
            checkPasswordHeightConstraint.deactivate()
        } else if textField == emailTextField {
            emailStackView.removeArrangedSubview(incorrectFormatEmailLabel)
            incorrectFormatEmailLabel.removeFromSuperview()
            emailHeightConstraint.deactivate()
        }
    }
}
