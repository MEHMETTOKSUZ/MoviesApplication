//
//  SignnInViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
