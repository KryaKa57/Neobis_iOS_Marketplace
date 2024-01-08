//
//  MyProductView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 05.01.2024.
//

import Foundation
import UIKit
import SnapKit

class MyProductView: UIView {
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty-box")
        return imageView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro-medium", size: 18)]
        label.attributedText = NSAttributedString(string: "Ой пусто!", attributes: textAttributes as [NSAttributedString.Key : Any])
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(rgb: 0xF7F6F9)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .white
        collectionView.isHidden = true
    }
    
    func setUI() {
        self.addSubview(collectionView)
        self.addSubview(emptyImageView)
        self.addSubview(emptyLabel)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.trailing.leading.equalToSuperview().inset(16)
        }
        self.emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height * 0.3)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(emptyImageView.snp.width).multipliedBy(1.2)
        }
        self.emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    func hideUI(isCollectionEmpty: Bool) {
        if isCollectionEmpty {
            backgroundColor = UIColor.white
            collectionView.isHidden = true
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
        } else {
            backgroundColor = UIColor(rgb: 0xF7F6F9)
            collectionView.isHidden = false
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
        }
            
    }
}


