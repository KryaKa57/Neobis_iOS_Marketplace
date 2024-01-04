//
//  ProductCell.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 03.01.2024.
//

import Foundation
import UIKit

class ProductCell: UICollectionViewCell {
    static var identifier = "ProductCell"
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro-medium", size: 16)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro-medium", size: 16)
        label.textColor = UIColor(rgb: 0x5D5FEF)
        return label
    }()
    
    let likeCountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = UIColor(rgb: 0xC0C0C0)
        button.setTitleColor(UIColor(rgb: 0xC0C0C0), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeCountButton)
        
        itemImageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview().inset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.trailing.leading.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.trailing.leading.equalToSuperview().inset(8)
        }
        
        likeCountButton.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with item: Product) {
        guard let url = URL(string: item.product_image ?? "" ) else { return }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.itemImageView.image = UIImage(data: data!)?.resize(targetSize: CGSize(width: 150, height: 80))
            }
        }
        
        nameLabel.text = item.title
        priceLabel.text = "\(item.price.formattedWithSeparator) $"
        likeCountButton.setTitle("\(item.likes_count)", for: .normal)
    }
}


