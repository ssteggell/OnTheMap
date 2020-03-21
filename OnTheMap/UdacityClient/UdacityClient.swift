//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/10/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UdacityClient {
    
//    var accountKey: String = ""
//    var createdAt : String = ""
//    var firstName : String = ""
//    var lastName : String = ""
//    var latitude : Double = 0.0
//    var longitude : Double = 0.0
//    var mapString : String = ""
//    var mediaURL : String = ""
//    var objectId : String = ""
//    var uniqueKey : String = ""
//    var updatedAt : String = ""
//    static let shared = UdacityClient()
    private struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
   
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case signUp
        case getUserData
        case getStudentLocation
        case postStudentLocation
        
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .signUp: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .getUserData: return Endpoints.base + "users/" + Auth.userId
            case .getStudentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"

                
            }
        }
        var url: URL {
        return URL(string: stringValue)!
        }
    }
     
    
  class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> ()){
    var request = URLRequest(url: Endpoints.login.url)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField: "Accept")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
   request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error)      in
     if let data = data {
       do {
         let range = 5..<data.count
         let newData = data.subdata(in: range)
         let response = try JSONDecoder().decode(LoginResponse.self, from: newData)
        print(response)
        DispatchQueue.main.async {
            Auth.userId = response.account.key!
            Auth.sessionId = response.session.id!
            completion(true, nil)
        }

       } catch {
        print(error)
        
        }
        }
    }
     task.resume()
    }
    
    class func getStudentLocation(completion: @escaping ([Student]?, Error?) -> ()){
        let request = URLRequest(url: Endpoints.getStudentLocation.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, reponse, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let studentLocation = try! decoder.decode(Results.self, from: data)
            //print(String(data: data, encoding: .utf8)!)
              print(studentLocation)
            completion(studentLocation.results, nil)
        }
        task.resume()
    }
    
    
}
    
    
    
    
   /* class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let request = LoginRequest(username: email, password: password)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: request, skipFirstFiveCharacters: true) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id!
                Auth.userId = response.account.key!
                //AppData.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, skipFirstFiveCharacters: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
            //"{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        //print("{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            if let response = response {
                completion(true, nil)
                
            }
            if let error = error {
                completion(false, error)
            }
                
                let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async{
                completion(responseObject, nil)
                }
        }
        }
                 
        task.resume()
        
        
    }*/
    /*func login(_ email: String,_ password: String, completion: @escaping (Bool, Error?) -> ()) {
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                return
            }
          
          /*func dispalyError(_ error: String){
              print(error)
          }
          
          guard (error == nil) else {
              completion (false, error)
              return
          }
          
          guard let data = data else {
              dispalyError("there is no data")
              return
          }
          guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
              dispalyError("the status code > 2xx")
              completion (false, error)
              return
          }*/
         let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
        //  print(String(data: newData!, encoding: .utf8)!)
            do {
            let decoder = JSONDecoder()
            let dataDecoded = try decoder.decode(loginResponse.self, from: newData!)
            let accountID = dataDecoded.account.key
            let accountRegister = dataDecoded.account.registered
            let sessionID = dataDecoded.session.id
            let sessionExpire = dataDecoded.session.expiration
            self.accountKey = accountID ?? ""
                print(":: Authentication Information ::")
                print("--------------------------")
                print("The account ID: \(String(describing: accountID!))")
                print("The account registered: \(String(describing: accountRegister!))")
                print("The session ID: \(String(describing: sessionID!))")
                print("The seesion expire: \(String(describing: sessionExpire!))")
                print("--------------------------\n")
                completion(true, nil)
                print("The login is done successfuly!")
            } catch let error {
               // dispalyError("could not decode data \(error.localizedDescription)")
                completion(false, nil)
                return
            }
             /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        }*/
    
    private func dispalyError(_ error: String){
        print(error)
    }
        

    

  //  print(String(data: newData!, encoding: .utf8)!)
//            guard let data = data else {
//                DispatchQueue.main.async{
//                completion(nil, error)
//                }
//                return
//            }
//             let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async{
//                completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                 //   let errorResponse = try decoder.decode(LoginResponse.self, from: data) as Error
//                DispatchQueue.main.async{
//                completion(nil, error)
//                }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//        }
    
    
    
    
    
    


