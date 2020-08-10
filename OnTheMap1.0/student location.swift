//
//  student location.swift
//  OnTheMap1.0
//
//  Created by Alexis Omar Marquez Castillo on 12/06/20.
//  Copyright © 2020 udacity. All rights reserved.
//

import Foundation
import UIKit

struct LoctationStudents: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let createdAt, firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    var accountKey: String?
    let objectID, uniqueKey, updatedAt: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
    
}
struct PostedStudentLocation: Codable {
    let createdAt: String
    let objectId: String
    
}


/*extension StudentLocationList {
 init(mapString: String, mediaURL: String) {
 self.mapString = mapString
 self.mediaURL = mediaURL
 }
 }*/

enum Param: String {
    case updatedAt
}
