//
//  ProfileEditCell.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 25.12.2023.
//

import Foundation
import UIKit

class ProfileEditCell: UITableViewCell {
    static var identifier = "ProfileEditCell"
    let cellTextField = UITextField()
    
    let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        backgroundColor = .white
        
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellTextField)
        
        separatorView.backgroundColor = UIColor(rgb: 0xF7F6F9)
        addSubview(separatorView)
        
        cellTextField.textColor = .black
        cellTextField.font = UIFont(name: "gothampro-medium", size: 14)
        //cellTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
        cellTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(profile: ProfileEditCellData) {
        if profile.text == nil {
            cellTextField.attributedPlaceholder = NSAttributedString(
                string: profile.placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC0C0C0)]
            )
        } else {
            cellTextField.text = profile.text
        }
    }
}
