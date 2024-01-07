//
//  ProfileTableViewCell.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 21.12.2023.
//

import Foundation
import UIKit

class ProfileCell: UITableViewCell {
    static var identifier = "ProfileCell"
    let cellImageView = UIImageView()
    let cellTextLabel = UILabel()
    let iconImageView = UIImageView()
    
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
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        cellTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellImageView)
        addSubview(cellTextLabel)
        addSubview(iconImageView)
        
        
        separatorView.backgroundColor = UIColor.gray
        
        cellImageView.backgroundColor = UIColor(rgb: 0x5458EA)
        cellImageView.layer.cornerRadius = 10
        cellImageView.contentMode = .center
        
        cellTextLabel.textColor = .black
        cellTextLabel.font = UIFont(name: "gothampro-medium", size: 14)
        
        iconImageView.image = UIImage(systemName: "chevron.right")
        iconImageView.tintColor = .black
        iconImageView.contentMode = .scaleAspectFit
        
        
        cellImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        cellTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(cellImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func configure(profile: ProfileCellData, image: String) {
        if let image = UIImage(named: profile.imageName)?.withRenderingMode(.alwaysOriginal) {
            let resizedImage = image.resize(targetSize: CGSize(width: 25, height: 25))
            cellImageView.image = resizedImage
        } else {
            let image = UIImage(systemName: "suit.heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white).resize(targetSize: CGSize(width: 25, height: 22))
            cellImageView.image = image
            
            addSubview(separatorView)
            separatorView.backgroundColor = UIColor(rgb: 0xF7F6F9)
            
            separatorView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        cellTextLabel.text = profile.labelText
    }
}


