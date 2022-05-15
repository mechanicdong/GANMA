//
//  EmailSignInViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import Foundation
import UIKit
import RxSwift
import JGProgressHUD

class EmailSignInViewController: UIViewController {
    let disposeBag = DisposeBag()
    let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailSignUpViewModel = EmailSignUpViewModel()
        bind(emailSignUpViewModel)
        attribute()
        layout()
    }
    
    private lazy var loginInfo: UILabel = {
        let loginInfo = UILabel()
        loginInfo.text = "로그인"
        
        return loginInfo
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "메일 주소 입력"
        emailTextField.keyboardType = .emailAddress
        emailTextField.becomeFirstResponder()
        
        return emailTextField
    }()
    
    private lazy var pwTextField: UITextField = {
        let pwTextField = UITextField()
        pwTextField.placeholder = "비밀 번호 입력(8글자 이상)"
        pwTextField.isSecureTextEntry = true
        
        return pwTextField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.alpha = 0.3
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    private func bind(_ viewModel: EmailSignUpViewModel) {
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.EmailTextInputted)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.pwTextInputted)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                viewModel.login()
                DispatchQueue.main.async {
                    self?.spinner.show(in: self?.view ?? UIView())
                }
            })
            .disposed(by: disposeBag)
                
        //정합성 체크하여 버튼 활성화
        viewModel.isValid()
            .observe(on: MainScheduler.instance)
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid()
            .observe(on: MainScheduler.instance)
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)

        viewModel.loginValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.spinner.dismiss(animated: true)
                    self?.dismiss(animated: true)
                } else { return }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.addSubview(stackView)
        [loginInfo, emailTextField, pwTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(loginButton)
    }
    
    private func layout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(20)
            $0.width.equalTo(view.snp.width)
            $0.leading.equalToSuperview().inset(20)
        }
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
    
}
