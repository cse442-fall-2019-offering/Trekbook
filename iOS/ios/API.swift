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
private let getmarkers_endpoint = "marker"

public var User: LoginStruct? = nil
public var UserList: UsersStruct? = nil
public var MarkersList: MarkersStruct? = nil

public struct MarkerSubmitStruct: Codable {
    let data: MarkerStruct
    let code: Int
    
    private enum CodingKeys: String, CodingKey {
        case data
        case code
    }
}

public struct MarkerStruct: Codable {
    let userid: Int
    let title: String
    let description: String
    let latitude: Float
    let longitude: Float
    
    private enum CodingKeys: String, CodingKey {
        case userid = "user_id"
        case title
        case description
        case latitude
        case longitude
    }
}

public struct MarkersStruct: Codable {
    let data: MarkerList
    let code: Int
    
    private enum CodingKeys: String, CodingKey {
        case data
        case code
    }
    
    struct MarkerList: Codable {
        let markers: [MarkerStruct]
        
        private enum CodingKeys: String, CodingKey {
            case markers = "markers"
        }
    }
}

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

public func api_submit_marker(userid: Int, title: String, description: String, latitude: Float, longitude: Float, callback: @escaping (_ success: Bool) -> Void) {
    let serviceUrl = URL(string: api_url + getmarkers_endpoint)!
    var dict = Dictionary<String, Any>()
    
    dict["user_id"] = userid
    dict["title"] = title
    dict["description"] = description
    dict["latitude"] = latitude
    dict["longitude"] = longitude
    
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let httpBody = try? JSONSerialization.data(withJSONObject: dict)
    request.httpBody = httpBody
        
    URLSession.shared.dataTask(with: request) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let decoder = JSONDecoder()
                 let apiData = try decoder.decode(MarkerSubmitStruct.self, from: data)
                
                if apiData.code == 200 {
                    callback(true)
                }
                
                callback(false)

             } catch let err {
                 print("Error", err)
          }
    }.resume()
}

private func getmarkers_querybuild(userid: Int) -> String {
    return getmarkers_endpoint + "?user=" + String(userid)
}

public func api_get_markers(userid: Int, callback: @escaping (_ success: Bool) -> Void) {
    let serviceUrl = URL(string: api_url + getmarkers_querybuild(userid: userid))!
    
    var request = URLRequest(url: serviceUrl)
    
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    let httpBody = try? JSONSerialization.data(withJSONObject: dict)
//    request.httpBody = httpBody
        
    URLSession.shared.dataTask(with: request) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let decoder = JSONDecoder()
                let apiData = try decoder.decode(MarkersStruct.self, from: data)
                
                if apiData.code == 200 {
                    MarkersList = apiData
                    callback(true)
                }
                
                callback(false)

             } catch let err {
                 print("Error", err)
          }
    }.resume()
}
