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
        nextScreen.delegate = self
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func addTargets() {
        profileView.endRegistrationButton.addTarget(self, action: #selector(registerPhoneButtonTapped(_:)), for: .touchUpInside)
    }
                                                    
    @objc func registerPhoneButtonTapped (_ sender:UIButton!) {
        let nextScreen = VerificationViewController(view: VerificationView(), viewModel: VerificationViewModel(), data: self.profileViewModel.profile?.email ?? "")
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
                self?.profileView.configure(username: user.username, image: user.profile_image ?? "")
            }
        }
        self.profileViewModel.onErrorMessage = { [weak self] error in
            print("no")
        }
    }
    
}

extension ProfileViewController: PoppedViewControllerDelegate {
    func didPerformActionAfterPop(with: Product?) {
        self.profileViewModel.getUser()
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
        cell.configure(profile: profileViewModel.sections[indexPath.section][indexPath.row], image: "")
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
            case (0,0):
                let favoriteProductViewController = FavoriteProductViewController(view: FavoriteProductView(), viewModel: FavoriteViewViewModel())
                navigationController?.pushViewController(favoriteProductViewController, animated: true)
            case (0,1):
                let favoriteProductViewController = MyProductViewController(view: MyProductView(), viewModel: MyProductViewModel())
                navigationController?.pushViewController(favoriteProductViewController, animated: true)
            case (1,0):
                presentAlertView()
            default:
                break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentAlertView() {
        let alertViewController = CustomAlertViewController()
        alertViewController.delegate = self
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.configure(imageName: "logout-red"
                                      , messageText: "Вы действительно хотите выйти с приложения?"
                                      , acceptText: "Выйти", rejectText: "Отмена")
        present(alertViewController, animated: true, completion: nil)
    }
    
    
}

extension ProfileViewController: CustomAlertViewControllerDelegate {
    func didTapYesButton() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
