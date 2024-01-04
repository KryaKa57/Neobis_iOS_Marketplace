//
//  ProductDetailView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 03.01.2024.
//

import Foundation
import UIKit
import SnapKit

class ProductDetailView: UIView {
    private let systemBounds = UIScreen.main.bounds
    var checkPasswordHeightConstraint: Constraint!
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro-medium", size: 24)
        label.textColor = UIColor(rgb: 0x5D5FEF)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likedButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = UIColor(rgb: 0xC0C0C0)
        button.setTitleColor(UIColor(rgb: 0xC0C0C0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro-medium", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productShortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro", size: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Детальное описание"
        label.font = UIFont(name: "gothampro", size: 22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "gothampro", size: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
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
        backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(topImageView)
        self.addSubview(scrollView)
        
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(likedButton)
        scrollView.addSubview(productNameLabel)
        scrollView.addSubview(productShortDescriptionLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(productDescriptionLabel)
    }
    
    
    func configure(_ productDetail: Product) {
        guard let url = URL(string: productDetail.product_image ?? "" ) else { return }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.topImageView.image = UIImage(data: data!)
            }
        }
        
        let labelText = "\(productDetail.price.formattedWithSeparator) $"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "gothampro", size: 14)
        ]
        
        priceLabel.text = labelText
        let likedMesssage = "Нравится: \(productDetail.likes_count.formattedWithSeparator)"
        likedButton.setAttributedTitle(NSAttributedString(string: likedMesssage, attributes: attributes), for: .normal)

        
        productNameLabel.text = productDetail.title
        productShortDescriptionLabel.text = productDetail.short_description
        productDescriptionLabel.text = productDetail.description
    }
    
    private func setConstraints() {
        self.topImageView.snp.makeConstraints { make in
            make.top.trailing.leading.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(topImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().offset(16)
        }
        self.likedButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(systemBounds.width - 32)
        }
        self.productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(likedButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(16)
        }
        self.productShortDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(systemBounds.width - 32)
        }
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productShortDescriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(systemBounds.width - 32)
        }
        self.productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(systemBounds.width - 32)
        }
    }
}


