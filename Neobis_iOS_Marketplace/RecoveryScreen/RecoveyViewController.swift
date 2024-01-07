//
//  RecoveyViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation
import UIKit

class RecoveryViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let recoveryView = RecoveryView()
    let recoveryViewModel: RecoveryViewModel
    var email: String?
    
    override func loadView() {
        view = recoveryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTargets()
        self.addDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = ""
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let changeProfileButton = CustomNavigationButton()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 14)]
        
        changeProfileButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        changeProfileButton.tintColor = .black
        changeProfileButton.addTarget(self, action: #selector(changeButtonTapped(_:)), for: .touchUpInside)
            
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
            
        let eyeIconButtonItem = UIBarButtonItem(customView: changeProfileButton)
        self.tabBarController?.navigationItem.leftBarButtonItem = eyeIconButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    init(view: RecoveryView, viewModel: RecoveryViewModel, email: String) {
        self.recoveryViewModel = viewModel
        self.email = email
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func changeButtonTapped(_ sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addTargets() {
        recoveryView.nextButton.addTarget(self, action: #selector(sendAgain), for: .touchUpInside)
        
    }
    
    private func addDelegates() {
        recoveryView.phoneTextField.becomeFirstResponder()
        recoveryView.phoneTextField.delegate = self
    }
    
    @objc func sendAgain() {
        self.recoveryViewModel.getCode(from: email ?? "")
    }
}

extension RecoveryViewController: CodeInputViewDelegate {
    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String) {
        if (code == "1234") {
            guard let navigationController = self.navigationController else {
                return
            }

            // Find the target view controller to which you want to navigate back
            for viewController in navigationController.viewControllers {
                if viewController is ProfileViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
}
