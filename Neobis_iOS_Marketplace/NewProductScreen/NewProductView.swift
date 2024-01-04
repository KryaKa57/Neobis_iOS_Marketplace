//
//  NewProductView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit
import SnapKit

class NewProductView: UIView {
    private let systemBounds = UIScreen.main.bounds
    var checkPasswordHeightConstraint: Constraint!
    
    var images = [UIImage]()
    
    lazy var choosePhotoButton: UIButton = {
        let button = UIButton(configuration: getButtonConfiguration())
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        return tableView
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
        self.addSubview(choosePhotoButton)
        self.addSubview(tableView)
    }
    
    private func setConstraints() {
        self.choosePhotoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(systemBounds.height * 0.15)
            make.leading.equalToSuperview().inset(32)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalTo(choosePhotoButton.snp.width).multipliedBy(1.3)
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(choosePhotoButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(32)
        }
    }
    
    func countEmptyTextFields() -> Int {
        var result = 0
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? TextFieldTableViewCell {
                    if let text = cell.textField.text, text.isEmpty {
                        result += 1
                    }
                }
            }
        }
        return result
    }
    
    func colorRed() {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? TextFieldTableViewCell {
                    if let text = cell.textField.text, text.isEmpty {
                        cell.textField.layer.borderWidth = 1
                        cell.textField.layer.borderColor = UIColor.red.cgColor
                        cell.textField.layer.cornerRadius = 12
                        cell.textField.setPlaceholderColor(.red)
                    }
                }
            }
        }
        
        if images.isEmpty {
            choosePhotoButton.layer.borderWidth = 1
            choosePhotoButton.layer.borderColor = UIColor.red.cgColor
            choosePhotoButton.layer.cornerRadius = 12
            choosePhotoButton.configuration = getButtonConfiguration(error: true)
        }
    }
    
    func getButtonConfiguration(error: Bool = false) -> UIButton.Configuration {        
        let color = error ? .red : UIColor(rgb: 0x5458EA)
        
        var container = AttributeContainer()
        container.font = UIFont(name: "gothampro-bold", size: 10)
        container.foregroundColor = color
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.imagePlacement = .top
        configuration.image = UIImage(named: "image-add")?.withTintColor(color).resize(targetSize: CGSize(width: 25, height: 25))
        configuration.attributedTitle = AttributedString("Добавить фото", attributes: container)
        configuration.titleAlignment = .center
        
        configuration.imagePadding = 4
        configuration.titleAlignment = .leading
        configuration.background.cornerRadius = 12
        
        return configuration
    }

    
    func updateImages() {
        var xOffset: CGFloat = systemBounds.width * 0.2 + 48
            
        for image in images.reversed() {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: xOffset, y: systemBounds.height * 0.15, width: systemBounds.width * 0.2, height: systemBounds.width * 0.26)
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            self.addSubview(imageView)
            xOffset += 90
        }
    }
    
}


