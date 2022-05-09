//
//  MyPageViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/04.
//

import Foundation
import UIKit
import RxSwift

class MyPageViewController: UIViewController {
    let disposeBag = DisposeBag()
    let emailSignUpViewModel = EmailSignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "MyPage"
        bind(EmailSignUpViewModel())
        setAttribute()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private lazy var myImage: UIImageView = {
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        myImage.image = UIImage(named: "logo_google")
        
        return myImage
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "환영합니다"
        welcomeLabel.textColor = .black
        
        return welcomeLabel
    }()
    
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = .black
        
        return nickNameLabel
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return lineView
    }()
    
    private lazy var signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle("SignUp / SignIn", for: .normal)
        signupButton.setTitleColor(UIColor.black, for: .normal)
        signupButton.layer.borderColor = UIColor.orange.cgColor
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 10
        
        return signupButton
    }()
    
    private lazy var signoutButton: UIButton = {
        let signoutButton = UIButton()
        signoutButton.setTitle("SignOut", for: .normal)
        signoutButton.setTitleColor(UIColor.black, for: .normal)
        signoutButton.layer.borderColor = UIColor.orange.cgColor
        signoutButton.layer.borderWidth = 1
        signoutButton.layer.cornerRadius = 10
        
        return signoutButton
    }()
    
    //TODO: 로그인 시 닉네임에 이메일주소 가져오기
    func bind(_ viewModel: EmailSignUpViewModel) {
        viewModel.getUser()
            .asDriver()
            .drive(self.nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        signoutButton.rx.tap //CotrolEvent
            .flatMap { [unowned self] _ in //Observable<Void>
                self.areYouSure()
            }
            .bind(to: viewModel.logout)
            .disposed(by: disposeBag)
        
    }
    
    func areYouSure() -> Observable<Void> {
        Observable.create { [unowned self] observer in
            let alert = UIAlertController(
                title: "Are you sure to sign out?",
                message: nil,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Yes", style: .destructive, handler: { [weak self]_ in
                    observer.onNext(())
                    let viewModel = EmailSignUpViewModel()
                    viewModel.logoutted()
                    print("로그아웃 성공?")
                    observer.onCompleted()
                }
            ))
            alert.addAction(UIAlertAction(
                title: "No", style: .default, handler: { _ in
                    observer.onCompleted()
                }
            ))

            self.present(alert, animated: true)
            return Disposables.create()
        }
    }
    
    private func setAttribute() {
        [myImage, welcomeLabel, nickNameLabel, lineView, signupButton, signoutButton].forEach {
            view.addSubview($0)
        }
        signupButton.addTarget(self, action: #selector(moveToLoginVC), for: .touchDown)
            
    }
    
    @objc func moveToLoginVC() {
        //let vc = LoginViewController()
        let vc = UINavigationController(rootViewController: LoginViewController())
        //navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func setLayout() {
        myImage.layer.cornerRadius = myImage.frame.height/2
        myImage.layer.borderWidth = 1
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
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(myImage.snp.bottom).offset(30)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        signoutButton.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
}

//extension Reactive where Base: MyPageViewController {
//    var presentAlert: Binder<String> {
//        return Binder(base) { base, message in
//            let alertController = UIAlertController(title: "Are you sure to sign out?", message: message, preferredStyle: .alert)
//
//            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
//            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: nil)
//            alertController.addAction(noAction)
//            alertController.addAction(yesAction)
//
//            base.present(alertController, animated: true)
//        }
//    }
//}
