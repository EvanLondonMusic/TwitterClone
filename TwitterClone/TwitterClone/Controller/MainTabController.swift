//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Evan London on 29.01.2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseAuth

class MainTabController: UITabBarController {
    
    // MARK: - Properties:
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        authentificateUserAndConfigureUI()
//        configureViewControllers()
//        configureUI()
        tabBar.isTranslucent = true
        
        
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUser()
    }
    
    func authentificateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        print("Twitter")
    }
    
    // MARK: Helpers:
    
    func configureUI() {
        view.addSubview(actionButton)
        //        actionButton.translatesAutoresizingMaskIntoConstraints = false
        //        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        //        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        //        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
        //        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        actionButton.layer.cornerRadius = 56 / 2
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 36, width: 56, height: 56)
        
    }
    
    func configureViewControllers() {
        
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), name: "Home", rootViewController: feed)
        
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), name: "Search", rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), name: "Notifications", rootViewController: notifications)
        
        let conversations = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), name: "Messages", rootViewController: conversations)
        
        self.setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        //        self.viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, name: String?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.title = name
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        //        nav.viewControllers.first?.navigationItem.title = "Home"
        
        return nav
    }
    
}
