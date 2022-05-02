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
    }
    
    private func setNavigationBar() {
        navigationItem.title = "이메일주소로 등록 및 로그인"
        navigationItem.largeTitleDisplayMode = .never
    }
}
