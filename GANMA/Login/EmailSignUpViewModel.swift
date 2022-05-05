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
        let email = EmailTextInputted
            .value
        print("\(email)")
        let password = pwTextInputted
            .value
        print("\(password)")
        
        Auth.auth().createUser(withEmail: email, password: password)
    }
    
}
