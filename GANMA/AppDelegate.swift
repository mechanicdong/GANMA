//
//  AppDelegate.swift
//  GANMA
//
//  Created by 이동희 on 2022/04/19.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    //구글 로그인 화면에서 구글에서 제공한 URL로 인증한 후 전달된 구글 로그인값을 처리
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //close view after google signIn success and add to Firebase 
        if let error = error {
            print("Error: Google Sign In \(error.localizedDescription)")
            return
        } else {
            let viewModel = EmailSignUpViewModel()
            viewModel.loginValid.onNext(true)
            //self.dismiss(animated: true, completion: nil)
        }

        guard let authentication = user.authentication else { return }
        //credential = 구글 ID Access Token 부여 받음
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        //Database 동일 계정 확인
        guard let email = user.profile.email,
              let givenName = user.profile.givenName
        else { return }

        DatabaseManager.shared.userExists(with: email) { exists in
            if !exists {
                //insert to database
                let chatUser = GanmaAppUser(nickName: givenName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        //upload image
                        
                    }
                }
            }
        }
        
        //받은 토큰을 Firebase 인증 정보에 등록
        Auth.auth().signIn(with: credential) { authResult, error in
            print("successfully signed in with google credencial")
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google User was disconnected!")
    }
    
    //show vc after google sign in, but not used this time
    private func showMainViewController() {
        //let vc = MyPageViewController()
        let vc = UINavigationController(rootViewController: LoginViewController())
        
        //vc.modalPresentationStyle = .pageSheet
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Firebase init
        FirebaseApp.configure()
        
        //Googld SignIn
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


