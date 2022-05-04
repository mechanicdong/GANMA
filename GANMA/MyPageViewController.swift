//
//  MyPageViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/04.
//

import Foundation
import UIKit

class MyPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "MyPage"
        setAttribute()
        setLayout()
    }
    
    private lazy var myImage: UIImageView = {
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        myImage.image = UIImage(named: "logo_apple")
        
        return myImage
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "환영합니다"
        welcomeLabel.textColor = .black
        
        return welcomeLabel
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = .black
        
        return nickNameLabel
    }()
    
    private func setAttribute() {
        [myImage, welcomeLabel, nickNameLabel].forEach {
            view.addSubview($0)
        }

    }
    
    private func setLayout() {
        myImage.layer.cornerRadius = myImage.frame.height/2
        myImage.layer.borderWidth = 1
        //myImage.layer.borderColor = UIColor.clear.cgColor
        myImage.layer.borderColor = UIColor.black.cgColor
        // 뷰의 경계에 맞춰준다
        myImage.clipsToBounds = true
        
        myImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(myImage).offset(20)
            $0.leading.equalTo(myImage.snp.trailing).offset(20)
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            $0.leading.equalTo(welcomeLabel)
        }
    }
    
}
