//
//  LoginViewController.swift
//  neobis_ios_auth
//
//  Created by Alisher on 29.11.2023.
//

import UIKit

class LoginViewController: UIViewController {

    private var loginView: LoginView
    private var loginViewModel: LoginViewModel
    private let systemBounds = UIScreen.main.bounds
    
    var customTabBarController: CustomTabBarController?

    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTargets()
        self.assignRequestClosures()
        
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController {
            self.customTabBarController = tabBarController
        }
    }
    
    init(view: LoginView, viewModel: LoginViewModel = LoginViewModel()) {
        self.loginView = view
        self.loginViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func assignRequestClosures() {
        self.loginViewModel.onUserLogined = { [weak self] in
            DispatchQueue.main.async {
                self?.goToMainScreen()
            }
        }
        self.loginViewModel.onErrorMessage = { [weak self] error in
            DispatchQueue.main.async {
                self?.showLoginFailurePopUp()
            }
        }
    }
    
    private func addTargets() {
        loginView.enterButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(goToRegisterScreen), for: .touchUpInside)
        
        
        [loginView.loginTextField, loginView.passwordTextField].forEach({
            $0.addTarget(self, action: #selector(isFilled(_:)), for: .editingChanged)
        })
            
    }
    
    @objc private func isFilled(_ textField: UITextField) {
        guard
            let login = loginView.loginTextField.text, !login.isEmpty,
            let password = loginView.passwordTextField.text, !password.isEmpty
        else {
            loginView.enterButton.isEnabled = false
            return
        }
        loginView.enterButton.isEnabled = true
    }

    @objc func loginUser() {
        let loginData = Login(username: loginView.loginTextField.text ?? ""
                            , email: nil
                            , password: loginView.passwordTextField.text ?? "")

        loginViewModel.postData(loginData)
    }

    @objc func goToRegisterScreen() {
        let nextScreen = RegisterViewController(view: RegisterView(), viewModel: RegisterViewModel())
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }

    @objc func goToMainScreen() {
        self.navigationController?.pushViewController(CustomTabBarController(), animated: true)        
    }
    
    
    func showLoginFailurePopUp() {
        let safeAreaTopInset = view.safeAreaInsets.top
        let popUpView = UIView(frame: CGRect(x: 32, y: safeAreaTopInset - 64 , width: view.frame.width - 64, height: 64))
        
        popUpView.layer.cornerRadius = 16
        popUpView.backgroundColor = .red
        
        
        let iconImage = UIImage(systemName: "exclamationmark.circle.fill")
        let iconImageView = UIImageView(frame: CGRect(x: 16, y: popUpView.frame.height/2 - 16, width: 32, height: 32))
        iconImageView.image = iconImage
        iconImageView.tintColor = .white
        
        let messageLabel = UILabel(frame: CGRect(x: 56, y: 0, width: popUpView.frame.width, height: popUpView.frame.height))
        let textAttributes =  [
            NSAttributedString.Key.font: UIFont(name: "gothampro-medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFFFFFF)
            ]
        messageLabel.attributedText = NSAttributedString(string: "Неверный логин или пароль",
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSelected = false
    }
}
