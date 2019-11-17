//
//  ViewController.swift
//  iOS
//
//  Created by Dennis Fedorishin on 9/18/19.
//  Copyright © 2019 Trekbook. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController {
    @IBOutlet weak var LogoImageView: UIImageView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        UsernameTextField.setBottomBorder()
        PasswordTextField.setBottomBorder()
        PasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func login(_ sender: Any) {
        // make call to API
        api_login(username: UsernameTextField.text ?? "", password: PasswordTextField.text ?? "") { (success) in
            if success {
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "performLoginTransition", sender: self)
//                }
                DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "MapBoxView", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MapBoxViewController")
                UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
        }
        
    }
}
