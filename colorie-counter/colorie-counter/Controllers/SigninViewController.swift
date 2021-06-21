//
//  SigninViewController.swift
//  colorie-counter
//
//  
//

import UIKit
import Firebase

class SigninViewController: UIViewController {
    private var reference: DatabaseReference!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference(withPath: "users")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.text = ""
        passwordTF.text = ""
        signinBtn.layer.cornerRadius = 10
        signinBtn.isEnabled = false
    }
    @IBAction func confirmTaped(_ sender: UITextField) {
        if sender.text == passwordTF.text
        {
            signinBtn.isEnabled = true
            warningLabel.text = ""
        } else {
            signinBtn.isEnabled = false
            warningLabel.text = "Password don't match"
        }
    }
    
    @IBAction func signinTap(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            warningLabel.text = "Fields are empty"
            return
        }

        // createUser
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                self!.warningLabel.text = error!.localizedDescription
                return
            }

            guard let user = user else { return }
            let userRef = self?.reference.child(user.user.uid)
            userRef?.setValue(["email": user.user.email])
        }
    }

}
