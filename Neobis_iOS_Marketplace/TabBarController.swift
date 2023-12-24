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
        
        // Create view controllers for each tab
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .white
        mainViewController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "home-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25)), tag: 0)

        let walletViewController = UIViewController()
        walletViewController.view.backgroundColor = .white
        walletViewController.tabBarItem = UITabBarItem(title: "Кошелек", image: UIImage(named: "wallet-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25)), tag: 1)

        let messageViewController = UIViewController()
        messageViewController.view.backgroundColor = .white
        messageViewController.tabBarItem = UITabBarItem(title: "Чаты", image: UIImage(named: "chat-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25)), tag: 2)

        let profileViewController = ProfileViewController(view: ProfileView(), viewModel: ProfileViewModel())
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "user-tabbar")?.resize(targetSize: CGSize(width: 25, height: 25)), tag: 3)

        
        let firstVC = UINavigationController(rootViewController: mainViewController)
        let secondVC = UINavigationController(rootViewController: walletViewController)

        let thirdVC = UINavigationController(rootViewController: messageViewController)
        let fourthVC = UINavigationController(rootViewController: profileViewController)

        // Set view controllers for the tab bar
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]

        // Create a custom center button
        let centerButton = UIButton(type: .custom)
        centerButton.backgroundColor = .blue
        centerButton.layer.cornerRadius = 25
        centerButton.setImage(UIImage(systemName: "plus")?.withTintColor(.white), for: .normal)
        centerButton.imageView?.contentMode = .scaleAspectFit
        centerButton.frame.size = CGSize(width: 50, height: 50)
        centerButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)

        // Add the button to the tab bar
        tabBar.addSubview(centerButton)
        centerButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.height - (centerButton.bounds.height / 2) - 10)
        
        
        if let tabBarItems = tabBar.items {
            for tabBarItem in tabBarItems {
                tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
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
