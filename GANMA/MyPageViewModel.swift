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

protocol MyPageViewModelType {
    var imageObj: AnyObserver<Void> { get }
    
    var outImage: Observable<NSData> { get }
}

struct MyPageViewModel: MyPageViewModelType {
    let disposeBag = DisposeBag()
    //INPUT
    let imageObj: AnyObserver<Void>
    
    //OUTPUT
    let outImage: Observable<NSData>
    
    init() {
        let fetching = PublishSubject<Void>()
        let image = BehaviorSubject<NSData>(value: NSData())
        
        imageObj = fetching.asObserver()
        outImage = image //init
        
        fetching
            .flatMap(getImageData)
            .subscribe(onNext: image.onNext)
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
}
