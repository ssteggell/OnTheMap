//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/16/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation
import CoreLocation

struct Results: Codable {
    
    let results: [Student]
    
    
}
struct Student: Codable {

    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
//
//    var fullName: String {
//        return "\(firstName) \(lastName)"
//    }
}

class StudentModel {
    static var studentList = [Student]()
}
