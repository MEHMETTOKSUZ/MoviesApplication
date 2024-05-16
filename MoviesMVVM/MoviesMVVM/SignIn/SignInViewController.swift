//
//  SignnInViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import UIKit
import Lottie

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
        self.validateFields()
        self.view.endEditing(true)
        self.signIn {
            self.performSegue(withIdentifier: "toHomeViewControllerFromSingIn", sender: nil)
        } onError: { errorMessage in
            self.makeAlert(titleInput: "Error", messageInput: "The password is invalid or the user does not have a password.")

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
        Api.User.signIn(email: emailTextField.text!, password: passwordTextField.text!) {
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }
    }
    
    func validateFields() {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter Email!")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter Password!")
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
