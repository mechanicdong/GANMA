//
//  NewConversationViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/13.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private var spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        view.backgroundColor = .white
        setNavigation()
    }
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        searchBar.becomeFirstResponder()
        
        return searchBar
    }()
    
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tv
    }()
    
    private var noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()
    
    
    private func setNavigation() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
