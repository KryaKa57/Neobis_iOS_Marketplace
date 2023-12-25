//
//  ProfileEditViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 24.12.2023.
//

import Foundation
import UIKit

class ProfileEditViewController: UIViewController, UITextFieldDelegate {
    
    private let systemBounds = UIScreen.main.bounds
    let profileEditView = ProfileEditView()
    let profileEditViewModel: ProfileEditViewModel
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTargets()
        self.addDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.title = ""
        
        let saveProfileButton = CustomNavigationButton()
        let cancelProfileButton = CustomNavigationButton()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 14)]
        let saveButtonItem = UIBarButtonItem(customView: saveProfileButton)
        let cancelButtonItem = UIBarButtonItem(customView: cancelProfileButton)
        
        saveProfileButton.setAttributedTitle(NSAttributedString(string: "Готово", attributes: textAttributes as [NSAttributedString.Key : Any]), for: .normal)
        saveProfileButton.addTarget(self, action: #selector(saveSettings(_:)), for: .touchUpInside)
        
        
        cancelProfileButton.setAttributedTitle(NSAttributedString(string: "Отмена", attributes: textAttributes as [NSAttributedString.Key : Any]), for: .normal)
        cancelProfileButton.addTarget(self, action: #selector(cancelSettings(_:)), for: .touchUpInside)
            
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        self.tabBarController?.navigationItem.leftBarButtonItem = cancelButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    init(view: ProfileEditView, viewModel: ProfileEditViewModel) {
        self.profileEditViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelSettings(_ sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveSettings(_ sender:UIButton!) {
        
    }
    
    private func addTargets() {
        profileEditView.choosePhotoButton.addTarget(self, action: #selector(choosePhoto(_:)), for: .touchUpInside)
    }
    
    private func addDelegates() {
        profileEditView.tableView.separatorStyle = .none
        profileEditView.tableView.dataSource = self
        profileEditView.tableView.delegate = self
    }
    
    
    
    @objc private func choosePhoto(_ button: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        profileEditView.profilePhotoImageView.image = image
        dismiss(animated: true)
    }
    
    
}


extension ProfileEditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileEditViewModel.sections.count
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileEditViewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditCell.identifier, for: indexPath) as? ProfileEditCell else {
            return UITableViewCell()
        }
        
        cell.configure(profile: profileEditViewModel.sections[indexPath.section][indexPath.row])
        cell.cellTextField.tag = indexPath.row
        cell.cellTextField.delegate = self
        
        
        if (indexPath.row == 3 && indexPath.section == 0) ||
            (indexPath.row == 1 && indexPath.section == 1) {
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.clipsToBounds = true
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red.withAlphaComponent(0.2)
    }
        
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 8
    }
}
