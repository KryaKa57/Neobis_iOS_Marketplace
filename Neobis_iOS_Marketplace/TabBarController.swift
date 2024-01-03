//
//  TabBarController.swift
//  Neobis_iOS_Marketplace
//
//  Created by Alisher on 22.12.2023.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.tintColor = UIColor(rgb: 0x5458EA)
        
        let backButton = UIButton()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = .black
        
        let mainViewController = MainViewController(view: MainView(), viewModel: MainViewModel())
        let homeImage = UIImage(named: "home-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25))
        mainViewController.tabBarItem = UITabBarItem(title: "Главная", image: homeImage, tag: 0)

        let walletViewController = UIViewController()
        let walletImage = UIImage(named: "wallet-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25))
        walletViewController.view.backgroundColor = .white
        walletViewController.tabBarItem = UITabBarItem(title: "Кошелек", image: walletImage, tag: 1)

        let messageViewController = UIViewController()
        let messageImage = UIImage(named: "chat-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25))
        messageViewController.view.backgroundColor = .white
        messageViewController.tabBarItem = UITabBarItem(title: "Чаты", image: messageImage, tag: 2)

        let profileViewController = ProfileViewController(view: ProfileView(), viewModel: ProfileViewModel())
        let profileImage = UIImage(named: "user-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25))
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: profileImage, tag: 3)

        
        let firstVC = UINavigationController(rootViewController: mainViewController)
        let secondVC = UINavigationController(rootViewController: walletViewController)
        let thirdVC = UINavigationController(rootViewController: messageViewController)
        let fourthVC = UINavigationController(rootViewController: profileViewController)

        // Set view controllers for the tab bar
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]

        // Create a custom center button
        let centerButton = UIButton(type: .custom)
        let plusImage = UIImage(systemName: "plus")
        centerButton.backgroundColor = .blue
        centerButton.layer.cornerRadius = 30
        centerButton.setImage(plusImage, for: .normal)
        centerButton.tintColor = .white
        centerButton.imageView?.contentMode = .scaleAspectFit
        centerButton.frame.size = CGSize(width: 60, height: 60)
        centerButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)

        // Add the button to the tab bar
        tabBar.addSubview(centerButton)
        centerButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.height - (centerButton.bounds.height / 2) - 25)
        
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray,
                               NSAttributedString.Key.font: UIFont(name: "gothampro", size: 12)]
        if let tabBarItems = tabBar.items {
            for tabBarItem in tabBarItems {
                tabBarItem.setTitleTextAttributes(titleAttributes as [NSAttributedString.Key : Any], for: .normal)
            }
        }
        
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }

    @objc func centerButtonAction() {
        // Handle center button tap action
        print("Center button tapped")
    }
    
    
}
