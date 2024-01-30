//
//  NotificationsControllers.swift
//  TwitterClone
//
//  Created by Evan London on 29.01.2024.
//

import UIKit

class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Helpers:
    
    func configureUI() {
        view.backgroundColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navigationItem.title = "Notifications"
        
        
    }
}
