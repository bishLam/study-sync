//
//  University.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/24/25.
//

import Foundation
import Firebase

class University {
    var universityID: String
    var universityName: String
    var universityLocation : String
    var registeredDate: Timestamp
    
    init(universityID:String, universityName: String, universityLocation: String, registeredDate: Timestamp) {
        self.universityName = universityName
        self.universityLocation = universityLocation
        self.registeredDate = registeredDate
        self.universityID = universityID
    }
    
    convenience init(dictionary : [String: Any]) {
        self.init(
            universityID: dictionary["universityID"] as? String ?? "",
            universityName: dictionary["name"] as? String ?? "",
            universityLocation: dictionary["location"] as? String ?? "",
            registeredDate: dictionary["registeredDate"] as? Timestamp ?? Timestamp(date: Date())
        )
            
    }
    
    func toDictionary() -> [String: Any] {
        var uniDictionary: [String:Any] = [:]
        
        uniDictionary ["universityName"] = self.universityName
        uniDictionary ["universityLocation"] = self.universityLocation
        uniDictionary ["registeredDate"] = self.registeredDate
        return uniDictionary
    }
    
    
    func toString () -> String{
        return "universityID: \(universityID), universityName: \(universityName), universityLocation: \(universityLocation), registeredDate: \(registeredDate) ------------------------End------------------------"
    }
    
    
    
    
}
