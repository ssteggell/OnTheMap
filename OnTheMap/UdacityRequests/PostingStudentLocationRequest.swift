//
//  PostingStudentLocationRequest.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/22/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation


struct PostingStudentLocationRequest: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    
}
