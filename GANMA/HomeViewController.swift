//
//  HomeViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/19.
//

import Foundation
import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationController()
        
        self.addChild(menu)
        self.view.addSubview(menu.view)
        self.view.addConstraints(menu.view.constraints)
        menu.didMove(toParent: self)
    }
    
    func setNavigationController() {
        containerView.addSubview(leftItem)
        containerView.addSubview(rightItem)
        containerView.addSubview(topTitle)
        self.navigationItem.titleView = containerView
    }
    
    lazy var menu: UIViewController = {
        let menu = MenuScrollCollectionViewController()
        
        return menu
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))

        return containerView
    }()
    
    lazy var topTitle: UILabel = {
        let topTitle = UILabel(frame: CGRect(x: 0, y: -35, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = .systemFont(ofSize: 25, weight: .bold)
        topTitle.textColor = .systemYellow
        topTitle.text = "GANMA!"
        
        return topTitle
    }()
    
    lazy var leftItem: UIButton = {
        let leftItem = UIButton(frame: CGRect(x: -180, y: -35, width: 200, height: 18))
        leftItem.setImage(UIImage(systemName: "mail"), for: .normal)
        
        return leftItem
    }()
    
    lazy var rightItem: UIButton = {
        let rightItem = UIButton(frame: CGRect(x: 180, y: -35, width: 200, height: 18))
        rightItem.setImage(UIImage(systemName: "rectangle.badge.person.crop"), for: .normal)
        
        return rightItem
    }()
    


}
