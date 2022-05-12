//
//  AccountViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import RxViewController

class AccountViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setAttribute()
        setLayout()
        bind(MyPageViewModel())
    }
        
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeLoginVC))
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "logo_google")
        
        return imageView
    }()
    
    private func setNavigation() {
        view.backgroundColor = .white
        self.navigationItem.title = "계정 설정"
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setAttribute() {
        [imageView]
            .forEach {
                view.addSubview($0)
            }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchToChangeImage))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        
    }
    
    private func setLayout() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalTo(UIScreen.main.bounds.size.width*0.5)
            $0.width.height.equalTo(100)
        }
    }
    
    private func bind(_ viewModel: MyPageViewModel) {
        //--------------------
        //INPUT
        //--------------------
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in () }
        
        firstLoad.bind(to: viewModel.imageObj)
            .disposed(by: disposeBag)
        
        //--------------------
        //OUTPUT
        //--------------------
        viewModel.outImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.imageView.image = UIImage(data: data as Data)
            })
            .disposed(by: disposeBag)
        
    }

    @objc func closeLoginVC() {
        self.dismiss(animated: true)
    }
    
    @objc func touchToChangeImage() {
        let alert = UIAlertController(title: "프로필 사진 수정", message: nil, preferredStyle: .actionSheet)

        let pictureAction = UIAlertAction(title: "사진 촬영", style: .default, handler: { _ in
//            self.present(cameraVC, animated: true)
            self.checkCameraPermission()
        })
        
        let toAlbumAction = UIAlertAction(title: "앨범", style: .default, handler: nil)
        
        let cancelAction = UIAlertAction(title: "삭제", style: .destructive, handler: nil)
        
        [pictureAction, toAlbumAction, cancelAction].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true) {
            //dismiss when tap outside
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            alert.view.superview?.subviews[1].isUserInteractionEnabled = true
            alert.view.superview?.subviews[1].addGestureRecognizer(tap)
        }
    }
    
    func checkCameraPermission(){
        let cameraVC = UIImagePickerController()
        cameraVC.sourceType = .camera
        cameraVC.allowsEditing = true
        cameraVC.delegate = self
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
               DispatchQueue.global().async {
                   DispatchQueue.main.sync {
                       self.present(cameraVC, animated: true)
                   }
               }
           } else {
               print("Camera: 권한 거부")
           }
       })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage?
        
        if let picturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = picturedImage
        }
        
        self.imageView.image = newImage
        picker.dismiss(animated: true)
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
