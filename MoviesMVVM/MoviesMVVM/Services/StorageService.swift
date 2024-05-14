//
//  StorageService.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct StorageService {
    
    func savePhoto(username: String, uuid: String, data: Data, metaData: StorageMetadata, storageProfileReference: StorageReference, dic: Dictionary<String, Any>, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void)  {
        
        storageProfileReference.putData(data, metadata: metaData) { storageMetaData, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            storageProfileReference.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                            if error != nil {
                                print("cant change photo")
                            }
                        }
                    }
                    var dicTemp = dic
                    dicTemp["profileImage"] = metaImageUrl
                    
                    Reference().databaseSpesificUser(uuid: uuid).updateChildValues(dicTemp) { error, reference in
                        if error == nil {
                            onSuccess()
                        } else {
                            onError("Kullanıcı bilgileri güncellenirken bir hata oluştu.")
                        }
                    }
                } else {
                    onError("Profil resmi URL'si alınamadı.")
                }
            }
        }
    }
}

