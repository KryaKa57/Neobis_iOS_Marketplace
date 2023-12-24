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
    var checkPasswordHeightConstraint: Constraint!
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profilePhotoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        image.backgroundColor = UIColor(rgb: 0x5458EA)
        
        return image
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Алеся"
        label.textColor = .black
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
        self.addSubview(scrollView)
        scrollView.addSubview(profilePhotoStackView)
        scrollView.addSubview(tableView)
    }
    
    private func setConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.profilePhotoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(systemBounds.width/4)
            profilePhotoImageView.layer.cornerRadius = systemBounds.width/8
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.height.equalTo(systemBounds.width/8)
        }
        
        self.profilePhotoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(profilePhotoStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(systemBounds.width - 64)
            make.height.equalTo(300)
        }
    }
}

