//
//  RegistrationViewController.swift
//  iOS
//
//  Created by Dennis Fedorishin on 9/19/19.
//  Copyright © 2019 Trekbook. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBAction func signup(_ sender: Any) {
        api_signup(username: UserNameTextField.text ?? "", password: PasswordTextField.text ?? "", firstname: FirstNameTextField.text ?? "", lastname: LastNameTextField.text ?? "") { (success) in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "performSignUpTransition", sender: self)
                }
            }
        }
    }
    
}
