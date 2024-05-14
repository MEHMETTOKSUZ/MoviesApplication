//
//  SettingsViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 17.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var darkModSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getUserInfo()
    }
    
    @IBAction func darkModButtonClicked(_ sender: UISwitch) {
        
        if sender.isOn {
            ThemeHelper.switchToDarkMode()
        } else {
            ThemeHelper.switchToLightMode()
        }
    }
    
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogInScreenFromSettings", sender: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    private func configureUI() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        logOutButton.setTitleColor(.white, for: .normal)
        aboutButton.setTitleColor(.white, for: .normal)
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        emailLabel.font = UIFont.boldSystemFont(ofSize: 15)
        emailLabel.text = "Loading..."
        usernameLabel.text = "Loading..."
    }
    
    
    @IBAction func purchasedButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toPurchasedFromSettings", sender: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel))
        present(alert, animated: true)
        
    }
}


extension SettingsViewController {
    
    func getUserInfo() {
        
        UserInfo().fetchUserData { [weak self] fetchedUserInfo in
            guard let fetchedUserInfo = fetchedUserInfo else { return }
            
            DispatchQueue.main.async {
                self?.emailLabel.text = fetchedUserInfo.email
                self?.usernameLabel.text = fetchedUserInfo.username
                
                if let profileImageURL = fetchedUserInfo.profileImageURL {
                    self?.profileImage.downloaded(from: profileImageURL, contentMode: .scaleAspectFill)
                }
            }
        }
    }
}
