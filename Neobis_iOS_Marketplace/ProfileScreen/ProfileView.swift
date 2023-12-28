//
//  ProfileView.swift
//  neobis_ios_auth
//
//  Created by Alisher on 06.12.2023.
//

import Foundation
import UIKit
import SnapKit

class ProfileView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    lazy var profilePhotoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        image.backgroundColor = UIColor(rgb: 0x5458EA)
        image.layer.cornerRadius = systemBounds.width/10
        return image
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Алеся"
        label.textColor = .black
        label.font = UIFont(name: "gothampro", size: 18)
        return label
    }()
    
    lazy var profilePhotoStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(profilePhotoImageView)
        stack.addArrangedSubview(userNameLabel)
        return stack
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(rgb: 0xF7F6F9)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        return tableView
    }()
    
    lazy var checkPasswordStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    lazy var endRegistrationButton: UIButton = {
        let button = UIButton()
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont(name: "gothampro-medium", size: 14)]
        let attributedText = NSAttributedString(string: "Закончить регистрацию", attributes: titleAttributes as [NSAttributedString.Key : Any])
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = UIColor(rgb: 0x5458EA)
        button.layer.cornerRadius = 25
        return button
    }()
    
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
        self.addSubview(profilePhotoStackView)
        self.addSubview(tableView)
        self.addSubview(endRegistrationButton)
    }
    
    private func setConstraints() {
        self.profilePhotoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.15)
            make.centerX.equalToSuperview()
        }
        self.profilePhotoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(systemBounds.width/5)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.height.equalTo(systemBounds.width/8)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(profilePhotoStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(systemBounds.width - 48)
            make.height.equalTo(300)
        }
        self.endRegistrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(systemBounds.width - 48)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-systemBounds.height * 0.15)
        }
    }
}

