//
//  MyPageViewModel.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import FirebaseAuth

protocol MyPageViewModelType {
    var imageObj: AnyObserver<Void> { get }
    var accountBtnObj: AnyObserver<Void> { get }
    
    var outImage: Observable<NSData> { get }
    var outAccountButton: Observable<Bool> { get }
}

struct MyPageViewModel: MyPageViewModelType {
    let disposeBag = DisposeBag()
    //INPUT
    let imageObj: AnyObserver<Void>
    let accountBtnObj: AnyObserver<Void>
    
    //OUTPUT
    let outImage: Observable<NSData>
    let outAccountButton: Observable<Bool>
    
    init() {
        //About INPUT
        let fetching = PublishSubject<Void>()
        let fetchingAccountButton = PublishSubject<Void>()
        
        //About OUTPUT
        let image = BehaviorSubject<NSData>(value: NSData())
        let accountButton = BehaviorSubject<Bool>(value: false)
        
        imageObj = fetching.asObserver()
        accountBtnObj = fetchingAccountButton.asObserver()
        
        outImage = image
        outAccountButton = accountButton
        
        fetching
            .flatMap(getImageData)
            .subscribe(onNext: image.onNext)
            .disposed(by: disposeBag)
        
        fetchingAccountButton
            .flatMap(isGIDSignIn)
            .subscribe(onNext: accountButton.onNext)
            .disposed(by: disposeBag)
    }
    
    func getImageData() -> Observable<NSData> {
        return Observable.create { emitter in
            getImageDataFromURL { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getImageDataFromURL(onComplete: @escaping (Result<NSData, Error>) -> Void) {
        if let user = GIDSignIn.sharedInstance().currentUser {
            if let url = user.profile.imageURL(withDimension: 120),
               let data = NSData(contentsOf: url) {
                onComplete(.success(data))
            }
        }
    }
    
    func isGIDSignIn() -> Observable<Bool> {
        return Observable.create { emitter in
            isGIDSignInFromGID { result in
                switch result {
                case let .success(isLoggedIn):
                    emitter.onNext(isLoggedIn)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func isGIDSignInFromGID(onComplete: @escaping (Result<Bool, Error>) -> Void) {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            onComplete(.success(true))
        } 
    }
}
