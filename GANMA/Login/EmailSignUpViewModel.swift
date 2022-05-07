//
//  EmailSignUpViewModel.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/03.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

struct EmailSignUpViewModel {
    let disposeBag = DisposeBag()
    
    //View -> ViewModel
    let EmailTextInputted = BehaviorRelay<String>(value: "")
    let pwTextInputted = BehaviorRelay<String>(value: "")
    
    //ViewModel -> View
    let emailInfo = BehaviorRelay<String>(value: "")
    let errorInfo = BehaviorRelay<String>(value: "형식이 올바르지 않습니다")
    let loginValid = BehaviorSubject<Bool>(value: false)
//    var loginInfo: Observable<LoginInfo> {
//        return Observable
//            .combineLatest(EmailTextInputted, pwTextInputted) { id, pw in
//                return LoginInfo(id: id, pw: pw)
//            }
//    }

    init() {
        
    }
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(EmailTextInputted, pwTextInputted)
            .map { username, password in
                return username.count > 0 && username.contains("@") && username.contains(".") && password.count > 7
            }
    }
    
    //Firebase email/pw authorization
    func createUser() {
        let email = EmailTextInputted.value
        print("\(email)")
        let password = pwTextInputted.value
        print("\(password)")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: //이미 가입한 계정일 때
                    //로그인하기
                    //loginUser(withEmail: email, password: password)
                    self.errorInfo.accept("이미 등록된 계정입니다.")
                    loginValid.onNext(false)
                default:
                    self.errorInfo.accept(error.localizedDescription)
                }
            }
        }
        
    }
    
    func login() {
        let email = EmailTextInputted.value
        let password = pwTextInputted.value
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorInfo.accept(error.localizedDescription)
                loginValid.onNext(false)
            } else {
                loginValid.onNext(true)
                emailInfo.accept(email)
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String) -> BehaviorSubject<Bool> {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorInfo.accept(error.localizedDescription)
                loginValid.onNext(false)
            } else {
                loginValid.onNext(true)
            }
        }
        return loginValid
    }
    
    func getUser() -> BehaviorRelay<String> {
        let email = Auth.auth().currentUser?.email ?? ""
        emailInfo.accept(email)
        
        return emailInfo
    }
}

struct LoginInfo {
    var id: String?
    var pw: String?
}

