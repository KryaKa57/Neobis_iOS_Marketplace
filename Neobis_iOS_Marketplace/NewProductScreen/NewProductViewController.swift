//
//  NewProductViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 04.01.2024.
//

import Foundation
import UIKit
import Cloudinary


class NewProductViewController: UIViewController {
    var lastImageURL = ""
    var data: Product? = nil
    
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
        
        PasswordTextField.appearance().tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if data == nil {
            self.navigationItem.title = ""
            self.navigationItem.leftBarButtonItem = cancelButtonItem
            self.navigationItem.rightBarButtonItem = saveButtonItem
        } else {
            self.tabBarController?.navigationItem.title = ""
            self.tabBarController?.navigationItem.leftBarButtonItem = cancelButtonItem
            self.tabBarController?.navigationItem.rightBarButtonItem = saveButtonItem
        }
        
    }
    
    init(view: NewProductView, viewModel: NewProductViewModel, with product: Product? = nil) {
        self.newProductViewModel = viewModel
        self.data = product
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        alertViewController.modalPresentationStyle = .overFullScreen // Set the presentation style
        present(alertViewController, animated: true, completion: nil)
    }
    
    private func addTargets() {
        newProductView.choosePhotoButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
    }

    private func addDelegates() {
        newProductView.tableView.dataSource = self
        newProductView.tableView.delegate = self
    }
    
    private func assignRequestClosures() {}
    
    
    func addProduct() {
        //print(newProductView.images.first)
        //print(imageToURL(image: newProductView.images.first!))
        //https://res.cloudinary.com/ddryobvpq/image/upload/v1704394990/dle9g581b0rye7h33ufh.jpg
        //ProductDetails
        
        var texts: [String] = []
        for section in 0..<newProductView.tableView.numberOfSections {
            for row in 0..<newProductView.tableView.numberOfRows(inSection: section) {
                if let cell = newProductView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? TextFieldTableViewCell {
                    if let text = cell.textField.text {
                        texts.append(text)
                    }
                }
            }
        }
        
        guard let imageData = newProductView.images.first!.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to JPEG data")
            return
        }
        
        let productData = ProductDetails(title: texts[1], short_description: texts[2], description: texts[3], price: Int(texts[0]) ?? 0, product_image: imageData.base64EncodedString())
        newProductViewModel.postData(productData)
    }
    
    func imageToURL(image: UIImage) -> String {
        let config = CLDConfiguration(cloudName: "ddryobvpq", apiKey: "349451583689634",apiSecret: "aJCFAR68g1-7q_sVJQbTQgBWOA4")
        let cloudinary = CLDCloudinary(configuration: config)

        let imageData = image.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
        let params = CLDUploadRequestParams()
        params.setTransformation(CLDTransformation().setWidth(300).setHeight(300).setCrop(.fill).setGravity(.auto))

        cloudinary.createUploader().signedUpload(data: imageData!, params: params, progress: { (progress) in
            // Handle upload progress
        }, completionHandler: { (result, error) in
            if let result = result, let secureURL = result.secureUrl {
                // Use secureURL for the uploaded image
                print("Uploaded image URL: \(secureURL)")
            } else {
                // Handle error
                print("Error uploading image: \(error.debugDescription)")
            }
        })

        return ""
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
        
        if data != nil {
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
