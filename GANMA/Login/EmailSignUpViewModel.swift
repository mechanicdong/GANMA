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
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

struct Input {
    let logButton: Observable<Void>
    let okayButton: Observable<Void>
}
struct OutPut {
    let displayAlert: Observable<Void>
}

struct EmailSignUpViewModel {
    let disposeBag = DisposeBag()

    //View -> ViewModel
    let EmailTextInputted = BehaviorRelay<String>(value: "")
    let pwTextInputted = BehaviorRelay<String>(value: "")
    let nickNameTextInputted = BehaviorRelay<String>(value: "")
    let logout = PublishSubject<Void>()
    //let forceLogout = BehaviorSubject<Bool>(value: false)
    let forceLogout = PublishSubject<Bool>()
    
    //ViewModel -> View
    let emailInfo = BehaviorRelay<String>(value: "")
    let errorInfo = BehaviorRelay<String>(value: "형식이 올바르지 않습니다")
    let nickNameObj: Observable<String>
    let loginValid = BehaviorSubject<Bool>(value: false)
    let registerValid = BehaviorSubject<Bool>(value: false)
    
    private enum Action {
        case tapped
        case okay
    }
    
    private enum State {
        case offline
        case online
        case check
    }
    
    init() {
        nickNameObj = nickNameTextInputted.asObservable()
    }
    
    func logoutted() {
        let fireBaseAuth = Auth.auth()
        do {
            try fireBaseAuth.signOut()
            print("logoutted")
        } catch let signOutError as NSError {
            print("ERROR: Sign out \(signOutError.localizedDescription)")
        }
    }

//    func transform(_ input: Input) -> OutPut {
//        let state = Observable.merge {
//            input.logButton.map(EmailSignUpViewModel.Action.okay)
//        }
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(EmailTextInputted, pwTextInputted)
            .map { username, password in
                return username.count > 0 && username.contains("@") && username.contains(".") && password.count > 7
            }
    }

    //Firebase email/pw authorization
    func createUser() {
        let nickName = nickNameTextInputted.value
        let email = EmailTextInputted.value
        let password = pwTextInputted.value
        
        // MARK: 여기서는 이메일 검증을 두 번함(공부용)
        DatabaseManager.shared.userExists(with: email) { exists in
            guard !exists else {
                //user already exists
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let code = (error as NSError).code
                    switch code {
                    case 17007: //이미 가입한 계정일 때
                        //로그인하기
                        //loginUser(withEmail: email, password: password)
                        self.errorInfo.accept("이미 등록된 계정입니다.")
                        self.loginValid.onNext(false)
                    default:
                        self.errorInfo.accept(error.localizedDescription)
                    }
                }
                let chatUser = GanmaAppUser(nickName: nickName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        //upload image
                        
                    }
                }
                registerValid.onNext(true)
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

//    func loginUser(withEmail email: String, password: String) -> BehaviorSubject<Bool> {
//        Auth.auth().signIn(withEmail: email, password: password) {  _, error in
//            if let error = error {
//                errorInfo.accept(error.localizedDescription)
//                loginValid.onNext(false)
//            } else {
//                loginValid.onNext(true)
//            }
//        }
//        return loginValid
//    }
    
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

