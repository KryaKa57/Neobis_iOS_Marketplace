//
//  CreatePasswordViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 20.12.2023.
//

import Foundation
import UIKit


class CreatePasswordViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let createPasswordView = CreatePasswordView()
    let createPasswordViewModel: CreatePasswordViewModel
    
    override func loadView() {
        view = createPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigation()
        
        self.addTargets()
        self.addDelegates()
        //self.assignRequestClosures()
        
        PasswordTextField.appearance().tintColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = createPasswordView.firstPasswordTextField.becomeFirstResponder()
    }
    
    init(view: CreatePasswordView, viewModel: CreatePasswordViewModel) {
        self.createPasswordViewModel = viewModel
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
        
        let eyeIconButton = CustomNavigationButton()
        eyeIconButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyeIconButton.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)

        let eyeIconButtonItem = UIBarButtonItem(customView: eyeIconButton)
        navigationItem.rightBarButtonItem = eyeIconButtonItem
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func eyeButtonTapped(_ sender:UIButton!) {
        sender.setImage(UIImage(systemName: createPasswordView.firstPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"), for: .normal)
        createPasswordView.firstPasswordTextField.isSecureTextEntry = !createPasswordView.firstPasswordTextField.isSecureTextEntry
        createPasswordView.secondPasswordTextField.isSecureTextEntry = !createPasswordView.secondPasswordTextField.isSecureTextEntry
    }
    
    private func addTargets() {
        [createPasswordView.secondPasswordTextField, createPasswordView.firstPasswordTextField].forEach({
            $0.addTarget(self, action: #selector(isEverythingCorrect(_:)), for: .editingChanged)
        })
        createPasswordView.nextButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
    }

    private func addDelegates() {
        createPasswordView.firstPasswordTextField.delegate = self
        createPasswordView.secondPasswordTextField.delegate = self
    }
    
//    private func assignRequestClosures() {
//        self.registerViewModel.onUserRegistered = { [weak self] in
//            DispatchQueue.main.async {
//                self?.goToNextScreen()
//            }
//        }
//        self.registerViewModel.onErrorMessage = { [weak self] error in
//            DispatchQueue.main.async {
//                if error == .invalidData {
//                    self?.showLoginFailurePopUp("Пользователь с таким логином или почтой уже существует")
//                } else {
//                    self?.showLoginFailurePopUp("Что-то пошло не так :/")
//                }
//            }
//        }
//    }
//
//    @objc private func postData(_ button: UIButton) {
//        let registerData = Register(username: registerView.createLoginTextField.text ?? ""
//                                    , email: registerView.emailTextField.text ?? ""
//                                    , password1: registerView.createPassTextField.text ?? ""
//                                    , password2: registerView.createPassTextField.text ?? "")
//        registerViewModel.postData(data: registerData)
//    }
    
    
    func showLoginFailurePopUp(_ errorText: String) {
        let safeAreaTopInset = view.safeAreaInsets.top
        let popUpView = UIView(frame: CGRect(x: 32, y: safeAreaTopInset - 64 , width: view.frame.width - 64, height: 64))
        
        popUpView.layer.borderWidth = 1.0
        popUpView.layer.borderColor = UIColor.red.cgColor
        popUpView.layer.cornerRadius = 16
        popUpView.backgroundColor = .white
        
        let messageLabel = UILabel(frame: CGRect(x: 16, y: 0, width: popUpView.frame.width, height: popUpView.frame.height))
        messageLabel.text = errorText
        messageLabel.textColor = .red // Red text color
        messageLabel.numberOfLines = 0
        
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


    @objc private func goToNextScreen() {
//        let nextScreen = SendMailController(view: SendMailView(), email: registerView.emailTextField.text ?? "")
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0x000000, alpha: 0)
//        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    @objc private func isEverythingCorrect(_ textField: UITextField) {
        guard
            let first = createPasswordView.firstPasswordTextField.text, !first.isEmpty,
            let second = createPasswordView.secondPasswordTextField.text, !second.isEmpty,
            first.count >= 8, second.count >= 8
        else {
            createPasswordView.removeTextFieldError()
            createPasswordView.nextButton.isEnabled = false
            return
        }
        
        if first == second {
            createPasswordView.removeTextFieldError()
            createPasswordView.nextButton.isEnabled = true
        } else {
            createPasswordView.displayTextFieldError()
            createPasswordView.nextButton.isEnabled = false
        }
            
            
    }
}

extension CreatePasswordViewController: UITextFieldDelegate {
    
}

