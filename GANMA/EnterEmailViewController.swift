//
//  EnterEmailViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import UIKit

class EnterEmailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar()
        attribute()
        layout()
    }
    
    private lazy var buttonBar: UIView = {
        let buttonBar = UIView()
        buttonBar.backgroundColor = .orange
        
        return buttonBar
    }()
    
    private lazy var loginInfo: UILabel = {
        let loginInfo = UILabel()
        loginInfo.text = "등록정보"
        
        return loginInfo
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "신규등록", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "로그인", at: 1, animated: true)
        
        return segmentControl
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
        view.addSubview(segmentControl)
        view.addSubview(buttonBar)
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = .clear
        
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 15) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "DINCondensed-Bold", size: 15) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.orange
        ], for: .selected)
                        
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        [loginInfo, emailTextField, pwTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        segmentControl.selectedSegmentIndex = 0
        
    }
    
    private func layout() {
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(40)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(20)
            $0.width.equalTo(view.snp.width)
            $0.leading.equalToSuperview().inset(20)
        }
        buttonBar.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.height.equalTo(5)
            $0.leading.equalTo(segmentControl.snp.leading)
            $0.width.equalTo(segmentControl.snp.width).multipliedBy(1 / CGFloat(segmentControl.numberOfSegments))
        }
    }
    
    private func setNavigationBar() {
        navigationItem.title = "이메일주소로 등록 및 로그인"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            let originX = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.x = originX
        }
    }
}


