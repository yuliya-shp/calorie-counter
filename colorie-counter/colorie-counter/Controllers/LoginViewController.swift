//
//  LoginViewController.swift
//  colorie-counter
//
//  
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private var reference: DatabaseReference!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 10
        signinBtn.layer.cornerRadius = 10
        
        reference = Database.database().reference(withPath: "users")
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let _ = user else { return }
            self?.performSegue(withIdentifier: "mainViewSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            warningLabel.text = "Fields are empty"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let _ = error {
                self?.warningLabel.text = "Error"
            } else if let _ = user {
                // переходим на новый экран
                self?.performSegue(withIdentifier: "mainViewSegue", sender: nil)
                return
            } else {
                self?.warningLabel.text = "No such user"
            }
        }
    }
    
    @IBAction func signinTap(_ sender: Any) {
    }
    
}
