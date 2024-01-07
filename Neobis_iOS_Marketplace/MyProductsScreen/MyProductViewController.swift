//
//  MyProductViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 05.01.2024.
//

import Foundation
import UIKit

class MyProductViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let myProductView = MyProductView()
    let myProductViewModel: MyProductViewModel

    override func loadView() {
        view = myProductView
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.title = "Мои товары"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro-bold", size: 14)]
        
        let backButton = CustomNavigationButton()
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
            
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        self.tabBarController?.navigationItem.leftBarButtonItem = backButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    init(view: MyProductView, viewModel: MyProductViewModel) {
        self.myProductViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addTargets() {
    }
    
    private func addDelegates() {
        myProductView.collectionView.dataSource = self
        myProductView.collectionView.delegate = self
        
        myProductViewModel.delegate = self
        myProductViewModel.delegateRequest = self
        
    }
    
    private func assignRequestClosures() {
        
    }
    
    @objc func showActionSheet() {
        let alertController = CustomActionSheet()
        alertController.delegate = self
        present(alertController, animated: true)
    }
}


extension MyProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myProductViewModel.numberOfItems()
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            
        let item = myProductViewModel.item(at: indexPath.item)
        cell.configure(with: item, editable: true)
        
        cell.editButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 48) / 2 // Adjust the spacing as needed
        return CGSize(width: width, height: width * 1.2) // Set cell size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myProductViewModel.didSelectItem(at: indexPath.item)
    }
}

extension MyProductViewController: MainViewModelDelegate {
    func didSelectItem(at index: Int) {
        let nextScreen = ProductDetailViewController(view: ProductDetailView(), viewModel: ProductDetailViewModel(), data: myProductViewModel.item(at: index))
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
}

extension MyProductViewController: APIRequestDelegate {
    func onSucceedRequest() {
        DispatchQueue.main.async {
            self.myProductView.collectionView.reloadData()
            
            if self.myProductViewModel.numberOfItems() == 0 {
                self.myProductView.backgroundColor = UIColor.white
                self.myProductView.collectionView.isHidden = true
                self.myProductView.emptyImageView.isHidden = false
                self.myProductView.emptyLabel.isHidden = false
            } else {
                self.myProductView.backgroundColor = UIColor(rgb: 0xF7F6F9)
                self.myProductView.collectionView.isHidden = false
                self.myProductView.emptyImageView.isHidden = true
                self.myProductView.emptyLabel.isHidden = true
            }
        }
        
    }
}

extension MyProductViewController: CustomActionDelegate, PoppedViewControllerDelegate {
    
    func onEditAction() {
        let view = NewProductView()
        let nextScreen = NewProductViewController(view: view, viewModel: NewProductViewModel(), with: myProductViewModel.item(at: myProductViewModel.selectedIndex))
        nextScreen.delegate = self
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    func onDeleteAction() {
        let alertViewController = CustomAlertViewController()
        alertViewController.configure(imageName: "trash-red", messageText: "Вы действительно хотите удалить данный товар?", acceptText: "Удалить", rejectText: "Отмена")
        
        alertViewController.delegate = self
        alertViewController.modalPresentationStyle = .overFullScreen // Set the presentation style
        present(alertViewController, animated: true, completion: nil)
    }
    
    func didPerformActionAfterPop(with item: Product?) {
        self.myProductViewModel.updateItem(to: item!)
        onSucceedRequest()
    }

}

extension MyProductViewController: CustomAlertViewControllerDelegate {
    func didTapYesButton() {
        myProductViewModel.deleteProduct(product: myProductViewModel.item(at: myProductViewModel.selectedIndex))
    }
}


