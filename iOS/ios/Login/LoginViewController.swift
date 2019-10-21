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

struct LoginStruct: Codable {
 
    let response: responseData?
    let code: Int?
    
    private enum CodingKeys: String, CodingKey {
        case response
        case code
    }
    
    struct responseData: Codable {
        let userId: Int?
        let firstName: String?
        let lastName: String?
        let username: String?
        let message: String?
        let errorType: String?
        
        private enum CodingKeys: String, CodingKey {
            case username
            case message
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case errorType = "error_type"
        }
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
        
        guard let apiUrl = URL(string: "https://google.com/endpoint/thing") else { return }
        URLSession.shared.dataTask(with: apiUrl) { (data, response
                 , error) in
                 guard let data = data else { return }
                 do {
                     let decoder = JSONDecoder()
                     let apiData = try decoder.decode(LoginStruct.self, from: data)
                    
                     // print data here
                     print(apiData.name)
                        
                     // make transition based on request response
//                     self.performSegue(withIdentifier: "performLoginTransition", sender: self)
                     
                 } catch let err {
                     print("Err", err)
              }
        }.resume()
        
    }
}
