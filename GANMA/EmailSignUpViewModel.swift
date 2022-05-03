//
//  EmailSignUpViewModel.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/03.
//

import Foundation
import RxSwift
import RxCocoa

struct EmailSignUpViewModel {
    let disposeBag = DisposeBag()
    
    //View -> ViewModel
    let EmailTextInputted = PublishRelay<String>()
    let pwTextInputted = PublishRelay<String>()
    
    init() {
        
    }
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(EmailTextInputted, pwTextInputted)
            .map { username, password in
                return username.count > 0 && username.contains("@") && username.contains(".") && password.count > 7
            }
    }
    
}
