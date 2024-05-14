//
//  SignUpViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PhotosUI
import FirebaseStorage


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImage.addGestureRecognizer(gestureRecognizer)

    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        self.validateFields()
                self.signUp {
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextFeild.text!) { [weak self] authResult, error in
                        guard let self = self else { return }
                        if let error = error {
                            print("Error signing in:", error.localizedDescription)
                            return
                        }
                        self.performSegue(withIdentifier: "toHomeViewControllerFromSignUp", sender: nil)
                    }
                } onError: { error in
                    print(error)
                }
            }
}

extension SignUpViewController: PHPickerViewControllerDelegate {
   
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImage.image = selectedImage
                        self.image = selectedImage
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func presentPicker() {
        var configuration: PHPickerConfiguration =  PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        let picker: PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension SignUpViewController {
    
    func signUp(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
            Api.User.signUp(withUsername: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextFeild.text!, image: self.image) {
                self.makeAlert(titleInput: "BİLDİRİM", messageInput: "Kullanıcı oluşturuldu. Giriş yapabilirsiniz!")
                onSuccess()
            } onError: { errorMessage in
                onError(errorMessage)
            }
        }
    
    func validateFields() {
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter username!")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter email!")
            return
        }
        
        guard let password = passwordTextFeild.text, !password.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter password!")
            return
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)

    }
}
