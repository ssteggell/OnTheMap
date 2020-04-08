//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Spencer Steggell on 4/7/20.
//  Copyright © 2020 Spencer Steggell. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
    
    
}

extension OTMResponse: LocalizedError{
    var errorDescription: String?{
        return statusMessage
    }
}
