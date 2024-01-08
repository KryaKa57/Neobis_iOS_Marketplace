//
//  VerificationViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 26.12.2023.
//

import Foundation
import UIKit

class VerificationViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let verificationView = VerificationView()
    let verificationViewModel: VerificationViewModel
    var email = ""
    
    override func loadView() {
        view = verificationView
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
        self.setNavigation()
    }
    
    init(view: VerificationView, viewModel: VerificationViewModel, data: String) {
        self.verificationViewModel = viewModel
        email = data
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func backButtonTapped(_ sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped(_ sender:UIButton!) {
        self.verificationViewModel.getCode(from: email)
        guard let phoneNumber = self.verificationView.phoneTextField.text else { return }
        
        let nextScreen = RecoveryViewController(view: RecoveryView(), viewModel: RecoveryViewModel(), email: email, phone: phoneNumber)
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func addTargets() {
        verificationView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func addDelegates() {
        verificationView.phoneTextField.delegate = self
    }
    
    private func setNavigation() {
        self.tabBarController?.navigationItem.title = ""
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let backButton = CustomNavigationButton()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 14)]
        
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.tabBarController?.navigationItem.leftBarButtonItem = backButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
        
    }
}


extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "X (XXX) XXX XX XX", phone: newString)
        return false
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch) // just append a mask character
            }
        }
        
        verificationView.nextButton.isEnabled = (result.count == mask.count)
        
        return result
    }
}
