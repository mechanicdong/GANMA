//
//  DatabaseManager.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/12.
//
// "(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']'"
// -> userExists의 email 관련 건


import Foundation
import FirebaseDatabase

//Singleton -> final
final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

// MARK: Account Management
extension DatabaseManager {
    
    //MARK: EmailSignUpViewModel createUser()에서 동일 이메일 검증하므로 알아만두자
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false) //중복값 없음
                return
            }
            completion(true)
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: GanmaAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail)
            .setValue(
            ["nickName": user.nickName]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        }
    }
}

struct GanmaAppUser {
    let nickName: String?
    let emailAddress: String //KEY
    
    //MARK: "(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']'" debug
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
    
    //TODO:
    //let profilePictureUrl: String
    
}
