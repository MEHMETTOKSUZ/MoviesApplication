//
//  UserInfo.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 8.05.2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class UserInfo {
    
    var email: String?
    var username: String?
    var profileImageURL: String?
    
    let currentUserID = Auth.auth().currentUser?.uid
    let databaseRef = Database.database().reference()
    
    func fetchUserData(completion: @escaping (UserInfo?) -> Void) {
        guard let currentUserID = currentUserID else {
            print("User is not logged in.")
            completion(nil)
            return
        }
        
        databaseRef.child("users").child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userData = snapshot.value as? [String: Any] else {
                print("User data not found")
                completion(nil)
                return
            }
            
            let userInfo = UserInfo()
            userInfo.email = userData["email"] as? String ?? "Email not found"
            userInfo.username = userData["username"] as? String ?? "Username not found"
            userInfo.profileImageURL = userData["profileImage"] as? String
            
            completion(userInfo)
        }) { (error) in
            print("Error fetching user data: \(error.localizedDescription)")
            completion(nil)
        }
    }
}



