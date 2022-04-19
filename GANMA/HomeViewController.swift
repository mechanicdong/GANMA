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
        layout()
    }
    
    func setNavigationController() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        
        let topTitle = UILabel(frame: CGRect(x: 0, y: -35, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = .systemFont(ofSize: 25, weight: .bold)
        topTitle.textColor = .systemYellow
        topTitle.text = "GANMA!"
        
        let leftItem = UIButton(frame: CGRect(x: -180, y: -35, width: 200, height: 18))
        leftItem.setImage(UIImage(systemName: "mail"), for: .normal)
        
        let rightItem = UIButton(frame: CGRect(x: 180, y: -35, width: 200, height: 18))
        rightItem.setImage(UIImage(systemName: "rectangle.badge.person.crop"), for: .normal)
        
        containerView.addSubview(leftItem)
        containerView.addSubview(rightItem)
        containerView.addSubview(topTitle)
        self.navigationItem.titleView = containerView
        
        //set scroll view
        let titles = [
            "Top", "신작", "소년만화", "청년만화", "판타지"
        ]

    }
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 10)
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let button1: UIButton = {
        let button = UIButton()
        button.setTitle("TOP", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    private let button2: UIButton = {
        let button = UIButton()
        button.setTitle("2", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    private let button3: UIButton = {
        let button = UIButton()
        button.setTitle("3", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    private let button4: UIButton = {
        let button = UIButton()
        button.setTitle("4", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    func layout() {
        view.addSubview(contentScrollView)
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(contentScrollView)
            $0.height.equalTo(contentScrollView.snp.height)
            $0.width.equalTo(contentScrollView.snp.width)
        }
        
        [button1, button2, button3, button4]
            .forEach {
                contentView.addSubview($0)
            }
        button1.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.width.height.equalTo(20)
        }
        button2.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.width.height.equalTo(20)
        }
        button3.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.width.height.equalTo(20)
        }
        button4.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.width.height.equalTo(20)
        }
    }

}
