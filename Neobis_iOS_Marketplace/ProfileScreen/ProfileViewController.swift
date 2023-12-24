//
//  ProfileViewController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 20.12.2023.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    private let systemBounds = UIScreen.main.bounds
    let profileView = ProfileView()
    let profileViewModel: ProfileViewModel
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigation()
        self.addTargets()
        self.addDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    init(view: ProfileView, viewModel: ProfileViewModel) {
        self.profileViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation() {
        self.navigationItem.title = "Профиль"
        
        let changeProfileButton = UIButton(type: .custom)
        changeProfileButton.setTitle("Изм.", for: .normal)
        changeProfileButton.setTitleColor(.black, for: .normal)
        changeProfileButton.imageView?.contentMode = .scaleAspectFit
        changeProfileButton.addTarget(self, action: #selector(changeButtonTapped(_:)), for: .touchUpInside)
        
        changeProfileButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        changeProfileButton.layer.cornerRadius = 10
        changeProfileButton.backgroundColor = UIColor(rgb: 0xC0C0C0, alpha: 0.2)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let eyeIconButtonItem = UIBarButtonItem(customView: changeProfileButton)
        navigationItem.rightBarButtonItem = eyeIconButtonItem
    }
    
    @objc func changeButtonTapped(_ sender:UIButton!) {
        
    }
    
    private func addTargets() {
        
    }
    
    private func addDelegates() {
        profileView.tableView.separatorStyle = .none
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileViewModel.sections.count
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewModel.sections[section].count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        cell.configure(profile: profileViewModel.sections[indexPath.section][indexPath.row])
        
        if indexPath.row == 1 && indexPath.section == 0 {
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
        } else if indexPath.row == 0 && indexPath.section == 0 {
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.clipsToBounds = true
        } else if indexPath.section == 1 {
            cell.layer.cornerRadius = 15
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

