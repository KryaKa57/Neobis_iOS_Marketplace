//
//  ProductDetailViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 03.01.2024.
//

import Foundation
import UIKit


class ProductDetailViewController: UIViewController {
    let productDetailView = ProductDetailView()
    let productDetailViewModel: ProductDetailViewModel
    
    override func loadView() {
        view = productDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigation()
        
        PasswordTextField.appearance().tintColor = .black
    }
    
    init(view: ProductDetailView, viewModel: ProductDetailViewModel, data: Product) {
        self.productDetailViewModel = viewModel
        productDetailView.configure(data)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation() {
        
        self.tabBarController?.navigationItem.title = ""
        self.navigationItem.title = ""
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let backButton = CustomNavigationButton()
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = backButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
