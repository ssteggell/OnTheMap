//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 3/12/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation


struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
