//
//  MainViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 29.12.2023.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let mainView = MainView()
    let mainViewModel: MainViewModel
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTargets()
        self.addDelegates()
        self.assignRequestClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    init(view: MainView, viewModel: MainViewModel) {
        self.mainViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupNavigationBar() {
        
        self.tabBarController?.navigationItem.title = ""
        
        let containerView = UIView(frame: CGRect(x: 16, y: 0, width: 220, height: 44))
        containerView.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage(named: "shopping-cart-small")) 
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 16, y: 0, width: 44, height: 44)
        
        let titleLabel = UILabel(frame: CGRect(x: 72, y: 4, width: 180, height: 44))
        titleLabel.text = "MOBI MARKET"
        titleLabel.font = UIFont(name: "gothampro-bold", size: 22)
        titleLabel.textColor = .black
        
        // Add image view and label to the container view
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        // Create a bar button item with the custom view
        let customBarButtonItem = UIBarButtonItem(customView: containerView)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = customBarButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc func changeButtonTapped(_ sender:UIButton!) {
        let nextScreen = ProfileEditViewController(view: ProfileEditView(), viewModel: ProfileEditViewModel())
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func addTargets() {
        
    }
             
    
    private func addDelegates() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        mainViewModel.delegate = self
    }
    
    private func assignRequestClosures() {
        
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.numberOfItems()
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            
        let item = mainViewModel.item(at: indexPath.item)
        cell.configure(with: item)
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 48) / 2 // Adjust the spacing as needed
        return CGSize(width: width, height: width * 1.2) // Set cell size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainViewModel.didSelectItem(at: indexPath.item)
    }
}

extension MainViewController: MainViewModelDelegate {
    func didSelectItem(at index: Int) {
        let nextScreen = ProductDetailViewController(view: ProductDetailView(), viewModel: ProductDetailViewModel(), data: mainViewModel.item(at: index))
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
}
