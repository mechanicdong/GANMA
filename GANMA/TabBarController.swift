//
//  TabBarController.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/19.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    private lazy var homeViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: HomeViewController())
        let tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "homepod"),
            tag: 0
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var publishViewController: UIViewController = {
        //let viewController = PublishViewController()
        let viewController = UINavigationController(rootViewController: MenuScrollCollectionViewController())
        
        let tabBarItem = UITabBarItem(
            title: "연재",
            image: UIImage(systemName: "calendar.badge.clock"),
            tag: 1
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var finishViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: FinishViewController())
        let tabBarItem = UITabBarItem(
            title: "완결",
            image: UIImage(systemName: "bookmark.square"),
            tag: 2
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var rankingViewController: UIViewController = {
        let viewController = RankingViewController()
        let tabBarItem = UITabBarItem(
            title: "랭킹",
            image: UIImage(systemName: "star.bubble"),
            tag: 3
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    private lazy var drawerViewController: UIViewController = {
        let viewController = DrawerViewController()
        let tabBarItem = UITabBarItem(
            title: "서랍",
            image: UIImage(systemName: "books.vertical"),
            tag: 4
        )
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [homeViewController, publishViewController, finishViewController, rankingViewController, drawerViewController]
    }
}
