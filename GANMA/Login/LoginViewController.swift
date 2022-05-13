//
//  LoginViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/02.
//

import Foundation
import UIKit
import AuthenticationServices //for apple login framework(=AS)
import GoogleSignIn
import Firebase
import CryptoKit //for nonce hash value
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    private var currentNonce: String?
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //close view after google sign in success
        //GIDSignIn.sharedInstance().delegate = self
        
        //Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        loginObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.didLoginNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        
        setNavigation()
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        //Google Sign In
//        GIDSignIn.sharedInstance().presentingViewController = self
    }

    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    //close view after google signIn success and add to Firebase 
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
////        if let error = error {
////            print("Error: Google Sign In \(error.localizedDescription)")
////            return
////        } else {
////            let viewModel = EmailSignUpViewModel()
////            viewModel.loginValid.onNext(true)
////            self.dismiss(animated: true, completion: nil)
////        }
////
////        guard let authentication = user.authentication else { return }
////        //credential = 구글 ID Access Token 부여 받음
////        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
////                                                       accessToken: authentication.accessToken)
////
////        //Database 동일 계정 확인
////        guard let email = user.profile.email,
////              let givenName = user.profile.givenName
////        else {
////            return
////        }
////
////        DatabaseManager.shared.userExists(with: email) { exists in
////            if !exists {
////                //insert to database
////                DatabaseManager.shared.insertUser(with: GanmaAppUser(nickName: "\(givenName)", emailAddress: email))
////            }
////        }
////
////        //받은 토큰을 Firebase 인증 정보에 등록
////        Auth.auth().signIn(with: credential) { authResult, error in
////            guard authResult != nil, error != nil else {
////                print("failed to log in with google credencial")
////                return
////            }
////            print("successfully signed in with google credencial")
////        }
//    }
    
    private lazy var appleSignInButton: UIStackView = {
        let appleSignInButton = UIStackView()
        
        return appleSignInButton
    }()
    
    private lazy var emailLogInButton: UIButton = {
        let emailLogInButton = UIButton.init(frame: .init())
        
        return emailLogInButton
    }()
    
    private lazy var googleLogInButton: UIButton = {
        let googleLogInButton = UIButton()

        return googleLogInButton
    }()
    
//    private lazy var googleLogInButton: GIDSignInButton = {
//        let googleLogInButton = GIDSignInButton()
//
//        return googleLogInButton
//    }()
    
    private lazy var appleLogInButton: UIButton = {
        let appleLogInButton = UIButton()
        
        return appleLogInButton
    }()
    
    private lazy var logInStackView: UIStackView = {
        let logInStackView = UIStackView()
        logInStackView.axis = .vertical
        logInStackView.alignment = .center
        logInStackView.distribution = .fillEqually
        logInStackView.backgroundColor = .gray
        //스택뷰 마진(버튼 테두리 가림 현상)
        logInStackView.isLayoutMarginsRelativeArrangement = true
        logInStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return logInStackView
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeLoginVC))
        
        return button
    }()
    
    @objc func closeLoginVC() {
        self.dismiss(animated: true)
    }
    
    private func setNavigation() {
        view.backgroundColor = .white
        self.navigationItem.title = "무료 회원 가입"
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func attribute() {
        view.addSubview(logInStackView)
        
        [emailLogInButton, googleLogInButton, appleLogInButton]
            .forEach { logInStackView.addArrangedSubview($0) }
        
        emailLogInButton.setTitle("이메일/비밀번호로 계속하기", for: .normal)
        emailLogInButton.addTarget(self, action: #selector(emailLogInButtonTapped), for: .touchDown)
        
        googleLogInButton.setTitle("구글계정으로 계속하기", for: .normal)
        googleLogInButton.setImage(UIImage(named: "logo_google"), for: .normal)
        googleLogInButton.addTarget(self, action: #selector(googleLogInButtonTapped), for: .touchDown)
        
        appleLogInButton.setTitle("애플계정으로 계속하기", for: .normal)
        appleLogInButton.setImage(UIImage(named: "logo_apple"), for: .normal)
        appleLogInButton.addTarget(self, action: #selector(appleLogInButtonTapped), for: .touchDown)
    }
    @objc func emailLogInButtonTapped() {
        let viewController = EnterEmailViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func googleLogInButtonTapped() {
        GIDSignIn.sharedInstance().signIn() //구글에게 권한 위임
    }
    
    @objc func appleLogInButtonTapped() {
        self.startSignInWithAppleFlow()
    }
    
    private func layout() {
        
        logInStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview().offset(view.frame.height/3)
            $0.leading.trailing.equalToSuperview()
        }
        [emailLogInButton, googleLogInButton, appleLogInButton].forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 20
        }
        emailLogInButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(70)
            $0.bottom.equalTo(googleLogInButton.snp.top).offset(-10)
        }
        googleLogInButton.snp.makeConstraints {
            $0.top.equalTo(emailLogInButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(emailLogInButton)
            $0.bottom.equalTo(appleLogInButton.snp.top).offset(-10)
        }
        appleLogInButton.snp.makeConstraints {
            $0.top.equalTo(googleLogInButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(googleLogInButton)
            $0.bottom.equalTo(logInStackView.snp.bottom).inset(5)
        }
    }
}

//Apple Sign in
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
//                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
//                mainViewController.modalPresentationStyle = .fullScreen
//                self.navigationController?.show(mainViewController, sender: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//Apple Sign in create nonce
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
