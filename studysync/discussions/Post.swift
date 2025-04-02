//
//  Post.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/28/25.
//

import Foundation
import FirebaseFirestore

class Post {
    var description: String
    var postedTime: Timestamp
    var userId: String
    
    init(description: String, postedTime: Timestamp, userId: String) {
        self.description = description
        self.postedTime = postedTime
        self.userId = userId
    }
    
    convenience init(dictionary: [String:Any]) {
        
        self.init(description: dictionary["description"] as? String ?? "",
                  postedTime: dictionary["postedTime"] as? Timestamp ?? Timestamp(),
                  userId: dictionary["posterUID"] as? String ?? "")

    }
}

