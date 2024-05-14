//
//  UserApi.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit

struct UserApi {
    
    func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            } else {
                print(authDataResult?.user.uid ?? "")
                onSuccess()
            }
        }
    }
    
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        
        guard let selectedImage = image else {
            onError("Profil resmi seçilmedi.")
            return
        }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.4) else {
            onError("Resim verisi oluşturulamadı.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            guard let authData = authDataResult else {
                onError("AuthData sonuçları alınamadı.")
                return
            }
            
            let dic: [String: Any] = [
                UUID: authData.user.uid,
                EMAIL: authData.user.email ?? "",
                USERNAME: username,
                PROFILEIMAGE: "",
                STATUS: ""
                
            ]
          
            let storageProfileReference = Reference().storageSpesificProfile(uuid: authData.user.uid)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            StorageService().savePhoto(username: username, uuid: authData.user.uid, data: imageData, metaData: metadata, storageProfileReference: storageProfileReference, dic: dic) {
                onSuccess()
            } onError: { errorMessage in
                onError(errorMessage)
            }
        }
    }
}
