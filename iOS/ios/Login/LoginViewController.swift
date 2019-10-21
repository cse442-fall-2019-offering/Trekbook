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
 
    let data: responseData?
    let code: Int?
    
    private enum CodingKeys: String, CodingKey {
        case data
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
        
        let Url = String(format: "http://0.0.0.0:8000/v1/login")
        guard let serviceUrl = URL(string: Url) else { return }
        var dict = Dictionary<String, Any>()

        dict["username"] = self.UsernameTextField.text
        dict["password"] = self.PasswordTextField.text
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: dict)
        request.httpBody = httpBody
        
        print(request.httpBody)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                 guard let data = data else { return }
                 do {
                     let decoder = JSONDecoder()
                     let apiData = try decoder.decode(LoginStruct.self, from: data)
                    
                    if apiData.code! == 200 {
                        DispatchQueue.main.async {
                             self.performSegue(withIdentifier: "performLoginTransition", sender: self)
                         }
                    }
                 
                     // print data here
                     print(apiData)

                     // make transition based on request response
//                     self.performSegue(withIdentifier: "performLoginTransition", sender: self)

                 } catch let err {
                     print("Err", err)
              }
        }.resume()
        
    }
}
