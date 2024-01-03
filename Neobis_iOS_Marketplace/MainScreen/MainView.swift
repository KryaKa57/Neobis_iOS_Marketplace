//
//  MainView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 29.12.2023.
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView {
    private let systemBounds = UIScreen.main.bounds
    
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
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = UIColor(rgb: 0xF7F6F9)
        self.addSubview(collectionView)
    }
    
    private func setConstraints() {
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(username: String) {
        print(username)
    }
}

