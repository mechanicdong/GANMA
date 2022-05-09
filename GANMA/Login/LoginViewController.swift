//
//  LoginViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import Foundation
import UIKit
import AuthenticationServices //for apple login framework
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        
        setNavigation()
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private lazy var appleSignInButton: UIStackView = {
        let appleSignInButton = UIStackView()
        
        return appleSignInButton
    }()
    
    private lazy var emailLogInButton: UIButton = {
        let emailLogInButton = UIButton.init(frame: .init())
        
        return emailLogInButton
    }()
    
//    private lazy var googleLogInButton: UIButton = {
//        let googleLogInButton = UIButton()
//
//        return googleLogInButton
//    }()
    
    private lazy var googleLogInButton: GIDSignInButton = {
        let googleLogInButton = GIDSignInButton()
        
        return googleLogInButton
    }()
    
    private lazy var appleLogInButton: UIButton = {
        let appleLogInButton = UIButton()
        
        return appleLogInButton
    }()
    
    private lazy var logInStackView: UIStackView = {
        let logInStackView = UIStackView()
        logInStackView.axis = .vertical
        logInStackView.alignment = .center
        logInStackView.distribution = .fillEqually
        logInStackView.backgroundColor = .gray
        //스택뷰 마진(버튼 테두리 가림 현상)
        logInStackView.isLayoutMarginsRelativeArrangement = true
        logInStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return logInStackView
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeLoginVC))
        
        return button
    }()
    
    @objc func closeLoginVC() {
        self.dismiss(animated: true)
    }
    
    private func setNavigation() {
        view.backgroundColor = .white
        self.navigationItem.title = "무료 회원 가입"
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func attribute() {
        view.addSubview(logInStackView)
        
        [emailLogInButton, googleLogInButton, appleLogInButton]
            .forEach { logInStackView.addArrangedSubview($0) }
        
        emailLogInButton.setTitle("이메일/비밀번호로 계속하기", for: .normal)
        emailLogInButton.addTarget(self, action: #selector(emailLogInButtonTapped), for: .touchDown)
        
//        googleLogInButton.setTitle("구글계정으로 계속하기", for: .normal)
//        googleLogInButton.setImage(UIImage(named: "logo_google"), for: .normal)
        googleLogInButton.addTarget(self, action: #selector(googleLogInButtonTapped), for: .touchDown)
        
        appleLogInButton.setTitle("애플계정으로 계속하기", for: .normal)
        appleLogInButton.setImage(UIImage(named: "logo_apple"), for: .normal)
        appleLogInButton.addTarget(self, action: #selector(appleLogInButtonTapped), for: .touchDown)
    }
    @objc func emailLogInButtonTapped() {
        //let viewController = EnterEmailViewController()
        print("Tapped!!!")
        let viewController = EnterEmailViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func googleLogInButtonTapped() {
        GIDSignIn.sharedInstance().signIn() //구글에게 권한 위임
    }
    
    @objc func appleLogInButtonTapped() {
        
    }
    
    private func layout() {
        
        logInStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview().offset(view.frame.height/3)
            $0.leading.trailing.equalToSuperview()
        }
        [emailLogInButton, googleLogInButton, appleLogInButton].forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 20
        }
        emailLogInButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(70)
            $0.bottom.equalTo(googleLogInButton.snp.top).offset(-10)
        }
        googleLogInButton.snp.makeConstraints {
            $0.top.equalTo(emailLogInButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(emailLogInButton)
            $0.bottom.equalTo(appleLogInButton.snp.top).offset(-10)
        }
        appleLogInButton.snp.makeConstraints {
            $0.top.equalTo(googleLogInButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(googleLogInButton)
            $0.bottom.equalTo(logInStackView.snp.bottom).inset(5)
        }
    }
}
