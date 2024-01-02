//
//  RegisterController.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let registerView = RegisterView()
    let registerViewModel: RegisterViewModel
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigation()
        
        self.addTargets()
        self.addDelegates()
    }
    
    init(view: RegisterView, viewModel: RegisterViewModel) {
        self.registerViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation() {
        self.navigationItem.title = "Регистрация"
        
        let backButton = CustomNavigationButton()
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = .black

        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addTargets() {
        [registerView.createEmailTextField, registerView.createLoginTextField].forEach({
            $0.addTarget(self, action: #selector(isFilled(_:)), for: .editingChanged)
        })
        registerView.nextButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
    }

    private func addDelegates() {
        registerView.createLoginTextField.delegate = self
        registerView.createEmailTextField.delegate = self
    }
    
    @objc private func goToNextScreen() {
        guard let login = registerView.createLoginTextField.text else { return }
        guard let email = registerView.createEmailTextField.text else { return }
        
        let nextScreen = CreatePasswordViewController(view: CreatePasswordView(), viewModel: CreatePasswordViewModel(), data: [login, email])
        
        
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    @objc private func isFilled(_ textField: UITextField) {
        guard
            let login = registerView.createLoginTextField.text, !login.isEmpty,
            let pass = registerView.createEmailTextField.text, !pass.isEmpty
        else {
            registerView.nextButton.isEnabled = false
            return
        }
        registerView.nextButton.isEnabled = true
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSelected = true
        textField.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSelected = false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func indicesOfValidRequirements(_ password: String) -> [Int] {
        var indices: [Int] = []
        if (password.count >= 8 && password.count <= 15) { indices.append(0) }
        if (password.contains(/[a-z]/) && password.contains(/[A-Z]/)) { indices.append(1) }
        if (password.contains(/[0-9]/)) { indices.append(2) }
        if (password.contains(/[^a-zA-Z0-9]/)) { indices.append(3) }
        return indices
    }
}

