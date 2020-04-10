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
    
   struct Auth {
        static var sessionId = ""
        static var userKey = ""
        static var firstName = ""
        static var lastName = ""
    }
    struct LocationDetail {
        static var longitudeVal: CLLocationDegrees = 0.0
        static var latitudeVal: CLLocationDegrees = 0.0
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
            case .getUserData: return Endpoints.base + "users/" + Auth.userKey
            case .getStudentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"

                
            }
        }
        var url: URL {
        return URL(string: stringValue)!
        }
    }
//     Request to pull verify login information and get a session ID.
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {

        let loginCreds = LoginCredentials(username: email, password: password)
        let loginRequest = LoginRequest(udacity: loginCreds)
        taskForPOSTRequest(extraCharFlag: true, acceptIncludeFlag: true, contentTypeIncludeFlag: true, url: Endpoints.login.url, responseType: LoginResponse.self, body: loginRequest) { (response, error) in
            if let response = response {
                if response.session.id != "" {
                    DispatchQueue.main.async {
                        Auth.userKey = response.account.key
                        Auth.sessionId = response.session.id
                        completion(true, nil)
                    }
                } else {
                    completion(false, error)
                }
            } else {
                DispatchQueue.main.async{
                completion(false, error)
                }
            }
        }
    }

//    Network request to get the students locations.
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
              print(studentLocation)
            completion(studentLocation.results, nil)
        }
        task.resume()
    }
    
//    Network request to post the student location.
    class func postStudentLocation(mapStringLocation:String,mediaUrlStr:String, completion:@escaping (Bool, Error?) -> Void)
    {
        print("Session Id: \(Auth.sessionId) UserKey: \(Auth.userKey) First Name: \(Auth.firstName)  Last Name: \(Auth.lastName)")
        let requestBody = PostingStudentLocationRequest(uniqueKey: Auth.sessionId, firstName: Auth.firstName, lastName: Auth.lastName, mapString:mapStringLocation , mediaURL: mediaUrlStr, latitude: self.LocationDetail.latitudeVal, longitude: self.LocationDetail.longitudeVal)
        
        taskForPOSTRequest(extraCharFlag:false, acceptIncludeFlag:false ,contentTypeIncludeFlag: true, url: Endpoints.postStudentLocation.url, responseType: PostingStudentLocationResponse.self, body: requestBody) {(response,error) in
            if let response = response
            {
                if response.objectId != ""
                {
                    DispatchQueue.main.async
                    {
                        completion(true,nil)
                    }
                }
                else
                {
                    completion(false,error)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
//  Network request to get the User Info to be able to post the information.
    class func getUserInfo(userKey: String, completion: @escaping( Bool, Error?) -> Void) {
        taskForGETRequest(extraCharFlag: true, url: Endpoints.getUserData.url
               , responseType: PublicUserDataGenResponse.self)
        {
                   (response,error) in
                   if let response = response
                   {
                       DispatchQueue.main.async
                       {
                        Auth.firstName = response.firstName
                        Auth.lastName = response.lastName
                           completion(true, nil)
                       }
                   }
                   else
                   {
                       DispatchQueue.main.async
                       {
                           completion(false, error)
                       }
                   }
               }
        
    }
    
//    Network requst used to validate the location the user entered.
    class func validateAddressEntered(address:String,completion:@escaping  (Bool,Error?) -> Void) -> Bool {
            var isValidated = false
            let locationManager = CLGeocoder()
            locationManager.geocodeAddressString(address, completionHandler: {
                (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                if let placemark = placemarks?[0]
                {
                    self.LocationDetail.latitudeVal = placemark.location!.coordinate.latitude
                    self.LocationDetail.longitudeVal = placemark.location!.coordinate.longitude
                    completion(true, error)
                    isValidated = true
                }
                    
                else
                {
                    completion(false,error)
                }
            }
        )
        
        return isValidated
    }
    
    class func deleteSession(completion:@escaping () -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
                              Auth.sessionId = ""
                                completion()
                            }
                        task.resume()
                  
              }
    
    
    
//    Task for get request, following the UDACITY instructions to skip the first 5 characters.
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(extraCharFlag: Bool,url:URL, responseType: ResponseType.Type,completion: @escaping(ResponseType?,Error?)->Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else
            {
                DispatchQueue.main.async
                {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if extraCharFlag
                {
                              let range = 5 ..< data.count
                              let newData = data.subdata(in: range)
                              data = newData
                }
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async
                {
                    completion(responseObject, nil)
                }
                
            }
            catch _
            {
                do{
                    let range = 5 ..< data.count
                    let newErrorData = data.subdata(in: range)
                    
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newErrorData)
                    DispatchQueue.main.async
                    {
                        completion(nil,errorResponse)
                    }
                }
                catch
                {
                    DispatchQueue.main.async
                    {
                        completion(nil, error)
                    }
                    
                }
                
            }
        }
        task.resume()
        return task
        
    }
    
//    Task for Post requests.
    @discardableResult class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(extraCharFlag: Bool,acceptIncludeFlag:Bool, contentTypeIncludeFlag:Bool, url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask
       {
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           if acceptIncludeFlag
           {
               request.addValue("application/json", forHTTPHeaderField: "Accept")
           }
           if contentTypeIncludeFlag
           {
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           }
           request.httpBody = try!JSONEncoder().encode(body)
           print(request.url?.absoluteString ?? "NA")
           print("DEBUG POST: \(String(describing: request.httpBody?.description))")
           let task = URLSession.shared.dataTask(with: request){data,response,error in
               guard var data = data else
               {
                   completion(nil,error)
                   return
               }
               let decoder = JSONDecoder()
               do
               {
                   if extraCharFlag
                   {
                                 let range = 5 ..< data.count
                                 let newData = data.subdata(in: range)
                                 data = newData
                   }
                   
                   let responseObject = try decoder.decode(responseType.self,from:data)
                   completion(responseObject,nil)
               }
               catch
               {
                   do
                   {
                       let range = 5 ..< data.count
                       let newErrorData = data.subdata(in: range)

                       let errorResponse = try decoder.decode(OTMResponse.self, from: newErrorData)
                       DispatchQueue.main.async
                       {
                           completion(nil,errorResponse)
                       }

                   }
                   catch
                   {
                       DispatchQueue.main.async
                       {
                           completion(nil,error)
                       }
                   }
               }
           }
           task.resume()
           return task
       }
        

    
}

