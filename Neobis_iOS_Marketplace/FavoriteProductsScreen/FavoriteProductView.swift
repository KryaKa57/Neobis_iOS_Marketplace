//
//  FavoriteProductView.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 05.01.2024.
//

import Foundation
import UIKit
import SnapKit

class FavoriteProductView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = UIColor.white
        self.addSubview(emptyImageView)
        self.addSubview(emptyLabel)
    }
    
    private func setConstraints() {
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
}


