//
//  ViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 2.05.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Lottie

class LogInViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var loginGoogleButton: UIButton!
    
    
    @IBOutlet weak var animationImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAnimation()
    }
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUpViewController", sender: nil)
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignInViewController", sender: nil)
        
    }
    
    @IBAction func LogInWithGoogleDidTapped(_ sender: Any) {
        self.logInWithGoggle()
        
    }
    
    func setUpAnimation() {
        
        let animation = LottieAnimationView(name: "animation")
        animation.contentMode = .scaleAspectFill
        animation.center = self.animationImageView.center
        animation.frame = self.animationImageView.bounds
        animation.loopMode = .loop
        animation.play()
        self.animationImageView.addSubview(animation)
        
        
    }
}


extension LogInViewController {
    
    func logInWithGoggle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Google Sign In Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                
                if let error = error {
                    print("Google Sign In Error: \(error.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: "toHomeViewControllerFromLogIn", sender: nil)
                }
            }
        }
    }
}
