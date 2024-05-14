//
//  Reference.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let REF_USER = "users"
let STORAGE_PROFİLE = "profile"
let URL_STORAGE_ROOT = "gs://moviesapp-a9ca4.appspot.com"
let EMAIL = "email"
let UUID = "id"
let USERNAME = "username"
let PROFILEIMAGE = "profileImage"
let STATUS = "status"

class Reference {
    
    let dataBaseRoot = Database.database().reference()
    
    var dataBaseUsers: DatabaseReference {
        return dataBaseRoot.child(REF_USER)
    }
    
    func databaseSpesificUser(uuid: String) -> DatabaseReference {
        return dataBaseUsers.child(uuid)
    }
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFİLE)
    }
    
    func storageSpesificProfile(uuid: String) -> StorageReference {
        return storageProfile.child(uuid)
    }
}
