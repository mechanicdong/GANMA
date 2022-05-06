//
//  EmailSignInViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import Foundation
import UIKit
import RxSwift


class EmailSignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = EmailSignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    //let enterEmailVC = EnterEmailViewController()
    private lazy var loginInfo: UILabel = {
        let loginInfo = UILabel()
        loginInfo.text = "등록정보"
        
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
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.text = "이메일/비밀번호 조건을 확인해 주세요"
        
        return errorLabel
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.titleLabel?.textColor = .white
        nextButton.setTitle("확인", for: .normal)
        nextButton.backgroundColor = .systemYellow
        nextButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        nextButton.layer.cornerRadius = 10
        nextButton.alpha = 0.3
        nextButton.isEnabled = false
        
        return nextButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    func bind(_ viewModel: EmailSignUpViewModel) {
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
        
        //정합성 체크하여 버튼 활성화
        viewModel.isValid()
            .observe(on: MainScheduler.instance)
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        viewModel.isValid()
//            .observe(on: MainScheduler.instance)
//            .bind(to: errorLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
        viewModel.isValid()
            .observe(on: MainScheduler.instance)
            .map { $0 ? 1 : 0.3 }
            .bind(to: nextButton.rx.alpha)
            .disposed(by: disposeBag)
        
        //Firebase email/pw authorization
        nextButton.rx.tap
            .subscribe(
                onNext: {
                    viewModel.createUser()
                    //self?.dismiss(animated: true)
                })
            .disposed(by: disposeBag)
        
        viewModel.errorInfo
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.errorLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.loginValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.dismiss(animated: true)
                } else { return }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.addSubview(stackView)
        [loginInfo, emailTextField, pwTextField, errorLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(nextButton)
    }
    
    private func layout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(20)
            $0.width.equalTo(view.snp.width)
            $0.leading.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }

}
