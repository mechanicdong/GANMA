//
//  ConversationsTabBarController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/13.
//

import Foundation
import UIKit
import JGProgressHUD

class ConversationsTabBarController: UITabBarController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [conversationsViewController, profileViewController]
    }
    
    private lazy var conversationsViewController: UIViewController = {
        let vc = ConversationsViewController()
        let navVc = UINavigationController(rootViewController: vc)
        
        return navVc
    }()
    
    private lazy var profileViewController: UIViewController = {
        let vc = UINavigationController(rootViewController: ProfileViewController())
        
        return vc
    }()
    
}



    
