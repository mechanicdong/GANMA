//
//  ConversationsViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/13.
//

import Foundation
import UIKit


class ConversationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                                  target: self,
                                                                                  action: #selector(didTapComposeButton))
        setAttribute()
        setLayout()
        fetchConversations()
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private lazy var noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = false
        
        return label
    }()
    
    private func setAttribute() {
        [tableView, noConversationsLabel].forEach {
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setLayout() {
        tableView.frame = view.bounds
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
}
        
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World!"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "안광희"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
