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
        setLayout()
        
        self.addChild(menu)
        self.view.addSubview(menu.view)
        didMove(toParent: self)
    }
    
    func setNavigationController() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        containerView.addSubview(leftItem)
        containerView.addSubview(rightItem)
        containerView.addSubview(topTitle)
        
        self.navigationItem.titleView = containerView
    }
    
    //TODO: 네비게이션 버튼 AutoLayout 적용할 것
    func setLayout() {
        leftItem.translatesAutoresizingMaskIntoConstraints = false
        leftItem.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(-180)
            $0.trailing.equalToSuperview().inset(180)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        rightItem.translatesAutoresizingMaskIntoConstraints = false
        rightItem.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(180)
            $0.trailing.equalToSuperview().inset(-180)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        topTitle.translatesAutoresizingMaskIntoConstraints = false
        topTitle.snp.makeConstraints {
            $0.leading.right.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
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
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = .systemFont(ofSize: 25, weight: .bold)
        topTitle.textColor = .systemYellow
        topTitle.text = "hoho!"
        
        return topTitle
    }()
    
    lazy var leftItem: UIButton = {
        let leftItem = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        leftItem.setImage(UIImage(systemName: "mail"), for: .normal)
        
        return leftItem
    }()
    
    lazy var rightItem: UIButton = {
        let rightItem = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        rightItem.setImage(UIImage(systemName: "rectangle.badge.person.crop"), for: .normal)
        
        return rightItem
    }()
    
    
    


}
