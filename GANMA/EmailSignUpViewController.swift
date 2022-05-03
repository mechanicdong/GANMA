//
//  EmailSignInViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import Foundation
import UIKit

class EmailSignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return emailTextField
    }()
    
    private lazy var pwTextField: UITextField = {
        let pwTextField = UITextField()
        pwTextField.placeholder = "비밀 번호 입력(8글자 이상)"
        
        return pwTextField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private func attribute() {
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        [loginInfo, emailTextField, pwTextField].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func layout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(20)
            $0.width.equalTo(view.snp.width)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
