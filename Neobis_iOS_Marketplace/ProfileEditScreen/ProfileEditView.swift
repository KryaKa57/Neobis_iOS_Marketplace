//
//  ProfileEditView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 24.12.2023.
//

import Foundation
import UIKit
import SnapKit

class ProfileEditView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
    lazy var profilePhotoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        image.backgroundColor = UIColor(rgb: 0x5458EA)
        image.layer.cornerRadius = systemBounds.width/10
        return image
    }()
    
    lazy var choosePhotoButton: UIButton = {
        let button = UIButton()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(rgb: 0x5458EA),
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 18)]
        let attributedText = NSAttributedString(string: "Выбрать фотографию", attributes: textAttributes as [NSAttributedString.Key : Any])
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    lazy var profilePhotoStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(profilePhotoImageView)
        stack.addArrangedSubview(choosePhotoButton)
        return stack
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(rgb: 0xF7F6F9)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: ProfileEditCell.identifier)
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
    }
    
    private func setConstraints() {
        self.profilePhotoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(systemBounds.height * 0.15)
            make.centerX.equalToSuperview()
        }
        self.profilePhotoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(systemBounds.width/5)
        }
        
        self.choosePhotoButton.snp.makeConstraints { make in
            make.height.equalTo(systemBounds.width/8)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(profilePhotoStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(systemBounds.width - 64)
            make.height.equalTo(800)
        }
    }
}
