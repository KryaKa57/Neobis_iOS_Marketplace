//
//  RecoveryView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 28.12.2023.
//

import Foundation
import UIKit
import SnapKit

class RecoveryView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    
    let phoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")?
                        .resize(targetSize: CGSize(width: 45, height: 45))
                        .withTintColor(UIColor(rgb: 0xFFFFFF, alpha: 0.5))
        
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(rgb: 0x5458EA)
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из СМС"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "gothampro-medium", size: 22)
        return label
    }()
    
    let phoneTextField = CodeInputView()
    
    lazy var nextButton = CustomButton(textValue: "Отправить еще раз", isPrimary: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = UIColor(rgb: 0xF7F6F9)
        nextButton.isEnabled = false
        self.addSubview(phoneIconImageView)
        self.addSubview(mainLabel)
        self.addSubview(phoneTextField)
        self.addSubview(nextButton)
    }
    
    private func setConstraints() {
        self.phoneIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(systemBounds.width / 5)
        }
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneIconImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(32)
        }
        self.nextButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
        }
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
