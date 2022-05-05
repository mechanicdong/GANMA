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
        //setLayout()
        
        self.addChild(menu)
        self.view.addSubview(menu.view)
        didMove(toParent: self)
    }
    
    func setNavigationController() {
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.title = topTitle.text
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
    }
    
    @objc func moveToMyPage() {
        let rootVC = MyPageViewController()
        self.navigationController?.pushViewController(rootVC, animated: true)
        print("Tapped")
    }
    
    lazy var menu: UIViewController = {
        let menu = MenuScrollCollectionViewController()
        
        return menu
    }()
    
//    lazy var containerView: UIView = {
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
//
//        return containerView
//    }()
    
    lazy var topTitle: UILabel = {
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.textColor = .systemYellow
        topTitle.text = "hoho!"
        
        return topTitle
    }()

    lazy var leftItem: UIBarButtonItem = {
        let leftItem = UIBarButtonItem(title: "왼쪽", style: .plain, target: self, action: nil)
        
        return leftItem
    }()
  
    lazy var rightItem: UIBarButtonItem = {
        let rightItem = UIBarButtonItem(title: "오른쪽", style: .plain, target: self, action: #selector(moveToMyPage))
        
        return rightItem
    }()
}
