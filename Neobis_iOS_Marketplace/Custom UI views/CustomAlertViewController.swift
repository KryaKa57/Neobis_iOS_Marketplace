//
//  CustomAlertViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit

protocol CustomAlertViewControllerDelegate: AnyObject {
    func didTapYesButton()
}


class CustomAlertViewController: UIViewController {
    weak var delegate: CustomAlertViewControllerDelegate?
    private let systemBounds = UIScreen.main.bounds
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "remove-circle")
        return imageView
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont(name: "gothampro-medium", size: 16)]
        
        let text = "Вы действительно хотите \n отменить добавление товара?"
        label.attributedText = NSAttributedString(string: text, attributes: titleAttributes as [NSAttributedString.Key : Any])
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont(name: "gothampro-medium", size: 14)]
        let attributedText = NSAttributedString(string: "Да", attributes: titleAttributes as [NSAttributedString.Key : Any])
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = UIColor(rgb: 0x5458EA)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нет", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeAllAlert(_:)), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createView()
    }
    
    private func createView() {
        let alertWidth: CGFloat = systemBounds.width - 64
        let alertHeight: CGFloat = 320
        
        let xPos = (view.frame.width - alertWidth) / 2
        let yPos = (view.frame.height - alertHeight) / 2
        
        backgroundView.frame = CGRect(x: xPos, y: yPos, width: alertWidth, height: alertHeight)
        
        view.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.7)
        view.addSubview(backgroundView)
        backgroundView.addSubview(iconImage)
        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(confirmButton)
        backgroundView.addSubview(rejectButton)
        
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(alertWidth / 2.5)
        }
        self.messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        self.confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        self.rejectButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    @objc func closeAllAlert(_ button: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func close(_ button: UIButton) {
        delegate?.didTapYesButton()
        dismiss(animated: true)
    }
}
