//
//  API.swift
//  iOS
//
//  Created by Dennis Fedorishin on 11/9/19.
//  Copyright © 2019 Trekbook. All rights reserved.
//

import Foundation

private let api_url = "http://0.0.0.0:8000/v1/"
private let login_endpoint = "login"
private let signup_endpoint = "signup"
private let getusers_endpoint = "users"

public var User: LoginStruct? = nil
public var UserList: UsersStruct? = nil

public struct UsersStruct: Codable{
    let data: userList
    let code: Int?
    
    private enum CodingKeys: String, CodingKey {
        case data
        case code
    }
    
    struct userList: Codable {
        let users: [userData]
        
        private enum CodingKeys: String, CodingKey {
            case users = "users"
        }
    }
    
    struct userData: Codable {
        let userId: Int
        let firstName: String
        let lastName: String
        let username: String
        let fullname: String
        let numbervisited: String
        
        private enum CodingKeys: String, CodingKey {
            case username
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case fullname = "fullname"
            case numbervisited = "numbervisited"
        }
    }
}

public struct LoginStruct: Codable {
 
    let data: responseData
    let code: Int
    
    private enum CodingKeys: String, CodingKey {
        case data
        case code
    }
    
    struct responseData: Codable {
        let userId: Int
        let firstName: String
        let lastName: String
        let username: String
        let fullname: String
        let numbervisited: String
        
        private enum CodingKeys: String, CodingKey {
            case username
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case fullname = "fullname"
            case numbervisited = "numbervisited"
        }
    }
}

public func api_signup(username: String, password: String, firstname: String, lastname: String, callback: @escaping (_ success: Bool) -> Void) {
    let serviceUrl = URL(string: api_url + signup_endpoint)!
    var dict = Dictionary<String, Any>()
    
    dict["username"] = username
    dict["password"] = password
    dict["firstname"] = firstname
    dict["lastname"] = lastname
    
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let httpBody = try? JSONSerialization.data(withJSONObject: dict)
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let decoder = JSONDecoder()
                 let apiData = try decoder.decode(LoginStruct.self, from: data)
                
                if apiData.code == 200 {
                    callback(true)
                }
                
                callback(false)

             } catch let err {
                 print("Error", err)
          }
    }.resume()
}

public func api_login(username: String, password: String, callback: @escaping (_ success: Bool) -> Void) {
    let serviceUrl = URL(string: api_url + login_endpoint)!
    var dict = Dictionary<String, Any>()
    
    dict["username"] = username
    dict["password"] = password
    
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let httpBody = try? JSONSerialization.data(withJSONObject: dict)
    request.httpBody = httpBody
        
    URLSession.shared.dataTask(with: request) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let decoder = JSONDecoder()
                 let apiData = try decoder.decode(LoginStruct.self, from: data)
                
                if apiData.code == 200 {
                    User = apiData
                    callback(true)
                }
                
                callback(false)

             } catch let err {
                 print("Error", err)
          }
    }.resume()
}

private func getusers_querybuild(userid: Int) -> String {
    return getusers_endpoint + "?user=" + String(userid)
}
    
public func api_getusers(userid: Int, username: String, callback: @escaping (_ success: Bool) -> Void) {
    let serviceUrl = URL(string: api_url + getusers_querybuild(userid: userid))!
//    var dict = Dictionary<String, Any>()
//
//    dict["username"] = username
//    dict["password"] = password
    
    var request = URLRequest(url: serviceUrl)
    
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    let httpBody = try? JSONSerialization.data(withJSONObject: dict)
//    request.httpBody = httpBody
        
    URLSession.shared.dataTask(with: request) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let decoder = JSONDecoder()
                 let apiData = try decoder.decode(UsersStruct.self, from: data)
                
                if apiData.code! == 200 {
                    UserList = apiData
                    callback(true)
                }
                
                callback(false)

             } catch let err {
                 print("Error", err)
          }
    }.resume()
}
