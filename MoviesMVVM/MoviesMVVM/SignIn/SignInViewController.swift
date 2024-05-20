//
//  SignnInViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import UIKit
import Lottie
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var animationImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAnimation()

    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        guard validateFields() else { return }
               
               self.view.endEditing(true)
               self.signIn {
                   self.performSegue(withIdentifier: "toHomeViewControllerFromSingIn", sender: nil)
               } onError: { errorMessage in
                   self.makeAlert(titleInput: "Error", messageInput: errorMessage)
               }
    }
    
    func setUpAnimation() {
        
        let animation = LottieAnimationView(name: "SignIn")
        animation.contentMode = .scaleAspectFill
        animation.center = self.animationImageView.center
        animation.frame = self.animationImageView.bounds
        animation.loopMode = .loop
        animation.play()
        self.animationImageView.addSubview(animation)
        
    }
}

extension SignInViewController {
    
    func signIn(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            onError("Email or password is missing")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            onSuccess()
        }
    }
    
    @discardableResult
    func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter Email!")
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter Password!")
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
