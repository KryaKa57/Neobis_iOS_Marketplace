//
//  NewProductViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit
import Cloudinary

protocol PoppedViewControllerDelegate: AnyObject {
    func didPerformActionAfterPop(with: Product?)
}

class NewProductViewController: UIViewController {
    var lastImageURL = ""
    var data: Product? = nil
    var onEdit = false
    
    weak var delegate: PoppedViewControllerDelegate?
    
    private let systemBounds = UIScreen.main.bounds
    
    let newProductView = NewProductView()
    let newProductViewModel: NewProductViewModel
    
    override func loadView() {
        view = newProductView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTargets()
        self.addDelegates()
        self.assignRequestClosures()
        
        if onEdit {
            self.newProductView.configure(imageUrlString: data?.product_image ?? "")
        }
        
        PasswordTextField.appearance().tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigation()
    }
    
    
    
    init(view: NewProductView, viewModel: NewProductViewModel, with product: Product? = nil) {
        self.newProductViewModel = viewModel
        self.data = product
        self.onEdit = (product != nil)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let saveProfileButton = CustomNavigationButton()
        let cancelProfileButton = CustomNavigationButton()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 14)]
        
        let saveButtonItem = UIBarButtonItem(customView: saveProfileButton)
        let cancelButtonItem = UIBarButtonItem(customView: cancelProfileButton)
        
        saveProfileButton.setAttributedTitle(NSAttributedString(string: "Готово", attributes: textAttributes as [NSAttributedString.Key : Any]), for: .normal)
        saveProfileButton.addTarget(self, action: #selector(saveAdding(_:)), for: .touchUpInside)
        
        
        cancelProfileButton.setAttributedTitle(NSAttributedString(string: "Отмена", attributes: textAttributes as [NSAttributedString.Key : Any]), for: .normal)
        cancelProfileButton.addTarget(self, action: #selector(cancelAdding), for: .touchUpInside)
            
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        let navigationItem = onEdit ? self.tabBarController?.navigationItem : self.navigationItem
        
        navigationItem?.title = ""
        navigationItem?.leftBarButtonItem = cancelButtonItem
        navigationItem?.rightBarButtonItem = saveButtonItem
    }
    
    
    @objc func saveAdding(_ sender: UIButton!) {
        if newProductView.images.isEmpty || newProductView.countEmptyTextFields() > 0 {
            newProductView.colorRed()
        } else {
            addProduct()
        }
    }
    
    @objc func cancelAdding() {
        if newProductView.images.isEmpty && newProductView.countEmptyTextFields() == 4 {
            navigationController?.popViewController(animated: true)
        } else {
            presentAlertView()
        }
    }
    
    func presentAlertView() {
        let alertViewController = CustomAlertViewController()
        alertViewController.delegate = self
        alertViewController.modalPresentationStyle = .overFullScreen
        present(alertViewController, animated: true, completion: nil)
    }
    
    private func addTargets() {
        newProductView.choosePhotoButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
    }

    private func addDelegates() {
        newProductView.tableView.dataSource = self
        newProductView.tableView.delegate = self
        
        newProductViewModel.delegate = self
    }
    
    private func assignRequestClosures() {}
    
    
    func addProduct() {
        var texts = newProductView.getTextFromTextFields()
        
        guard let imageData = newProductView.images.last!.jpegData(compressionQuality: 0.1) else {
            print("Error converting image to JPEG data")
            return
        }
        
        let parameters = ["title": texts[1], "short_description": texts[2], "description": texts[3], "price": texts[0]]
        newProductViewModel.sendFormDataWithAlamofire(data: parameters, image: imageData, method: onEdit, at: data?.id ?? 0)
    }
    

    @objc private func addImage() {
        newProductView.choosePhotoButton.layer.borderWidth = 0
        newProductView.choosePhotoButton.configuration = newProductView.getButtonConfiguration()
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func postData(_ button: UIButton) {}
    
    
}

extension NewProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        cell.textField.tag = indexPath.section
        cell.textField.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        
        var text = ""
        
        if onEdit {
            switch (indexPath.section) {
            case 0: text = "\(data?.price ?? 0)"
            case 1: text = data?.title ?? ""
            case 2: text = data?.short_description ?? ""
            case 3: text = data?.description ?? ""
            default: break
            }
        }
        
        cell.configure(newProductViewModel.placeholderValues[indexPath.section], with: text)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newProductViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
       
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.green
        return headerView
    }
       
}

extension NewProductViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        newProductViewModel.placeholderValues[textField.tag] = textField.text ?? ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}

extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[.imageURL] as? URL {
            lastImageURL = "\(imageURL)"
        }
        
        guard let image = info[.editedImage] as? UIImage else { return }
        newProductView.images.append(image)
        newProductView.updateImages()
        
        dismiss(animated: true)
        
    }
}

extension NewProductViewController: CustomAlertViewControllerDelegate {
    func didTapYesButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension NewProductViewController: APIRequestDelegate {
    func onSucceedRequest() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didPerformActionAfterPop(with: self.newProductViewModel.result!)
        }
    }
}
