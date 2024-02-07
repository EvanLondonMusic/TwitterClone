//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Evan London on 29.01.2024.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
    
    // MARK: - Properties
    
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var filterUsers = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
        !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        UISearchBar.appearance().tintColor = .black
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
            }
        }
    
    // MARK: Helpers:
    
    func configureUI() {
        view.backgroundColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.searchTextField.leftView?.tintColor = .darkGray
//        searchController.searchBar.searchTextField.tokenBackgroundColor = .red
        searchController.searchBar.searchTextField.textColor = .black
//        searchController.searchBar.searchTextField.tintColor = .black
//        searchController.searchBar.searchTextField.backgroundColor = .orange
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for a user", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
}


// MARK: - UItableViewDelagate/DataSource

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.selectionStyle = .none
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter({ $0.username.contains(searchText) || $0.fullname.contains(searchText) })
    }
}
