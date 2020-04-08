//
//  PublicUserDataResponse.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 4/8/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation

struct PublicUserDataGenResponse: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
