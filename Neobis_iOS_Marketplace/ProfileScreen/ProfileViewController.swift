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
        
        self.addTargets()
        self.addDelegates()
        self.assignRequestClosures()
        
        profileViewModel.getUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Профиль"
        
        let changeProfileButton = CustomNavigationButton()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                              NSAttributedString.Key.font:UIFont(name: "gothampro", size: 14)]
        
        changeProfileButton.setAttributedTitle(NSAttributedString(string: "Изм.", attributes: textAttributes as [NSAttributedString.Key : Any]), for: .normal)
        changeProfileButton.addTarget(self, action: #selector(changeButtonTapped(_:)), for: .touchUpInside)
            
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
            
        let eyeIconButtonItem = UIBarButtonItem(customView: changeProfileButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = eyeIconButtonItem
        self.tabBarController?.navigationItem.leftBarButtonItem?.isHidden = true
    }
    
    init(view: ProfileView, viewModel: ProfileViewModel) {
        self.profileViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func changeButtonTapped(_ sender:UIButton!) {
        let nextScreen = ProfileEditViewController(view: ProfileEditView(), viewModel: ProfileEditViewModel())
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func addTargets() {
        profileView.endRegistrationButton.addTarget(self, action: #selector(registerPhoneButtonTapped(_:)), for: .touchUpInside)
    }
                                                    
    @objc func registerPhoneButtonTapped (_ sender:UIButton!) {
        let nextScreen = VerificationViewController(view: VerificationView(), viewModel: VerificationViewModel())
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func addDelegates() {
        profileView.tableView.separatorStyle = .none
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
    private func assignRequestClosures() {
        self.profileViewModel.onSucceedRequest = { [weak self] user in
            DispatchQueue.main.async {
                self?.profileView.configure(username: user.username)
            }
        }
        self.profileViewModel.onErrorMessage = { [weak self] error in
            print("no")
        }
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

