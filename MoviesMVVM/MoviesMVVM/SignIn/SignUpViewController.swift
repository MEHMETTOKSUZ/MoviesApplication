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
import Lottie

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var animationImageView: UIImageView!
    
    var image: UIImage? = nil
    var animation: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAnimation()
        profileImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImage.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        guard validateFields() else { return }
        
        self.signUp {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextFeild.text!) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "toHomeViewControllerFromSignUp", sender: nil)
            }
        } onError: { errorMessage in
            self.makeAlert(titleInput: "Error", messageInput: errorMessage)
        }
    }
}

extension SignUpViewController: PHPickerViewControllerDelegate {
    
    func setUpAnimation() {
        animation = LottieAnimationView(name: "profile")
        guard let animation = animation else { return }
        animation.contentMode = .scaleAspectFill
        animation.frame = self.animationImageView.bounds
        animation.loopMode = .loop
        animation.play()
        self.animationImageView.addSubview(animation)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImage.image = selectedImage
                        self.image = selectedImage
                        self.animationImageView.isHidden = true
                        self.animation?.stop()
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension SignUpViewController {
    
    func signUp(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Api.User.signUp(withUsername: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextFeild.text!, image: self.image) {
            self.makeAlert(titleInput: "Notification", messageInput: "User created successfully. You can log in now!")
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }
    }
    
    @discardableResult
    func validateFields() -> Bool {
        guard let username = usernameTextField.text, !username.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter username!")
            return false
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter email!")
            return false
        }
        
        guard let password = passwordTextFeild.text, !password.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter password!")
            return false
        }
        
        return true
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
