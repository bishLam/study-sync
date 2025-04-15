//
//  Post.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/28/25.
//

import Foundation
import FirebaseFirestore

class Post {
    var postID:String!
    var description: String
    var postedTime: Timestamp
    var userId: String
    
    init(description: String, postedTime: Timestamp, userId: String) {
        self.description = description
        self.postedTime = postedTime
        self.userId = userId
    }
    
    convenience init(postID:String, dictionary: [String:Any]) {
        
        self.init(description: dictionary["description"] as? String ?? "",
                  postedTime: dictionary["postedTime"] as? Timestamp ?? Timestamp(),
                  userId: dictionary["posterUID"] as? String ?? "")
        self.postID = postID
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        
        dictionary["description"] = self.description
        dictionary["postedTime"] = self.postedTime
        dictionary["posterUID"] = self.userId
        
        return dictionary
    }
    
    func setTimeFormat() -> String{
        let currentTime = Timestamp(date: Date())
        let secondsDifference = currentTime.seconds - self.postedTime.seconds
        
        //display just now for the first 10 minutes of posting
        var postedTime:String!
        if secondsDifference < 600 {
           postedTime = "Just Now"
        }
        
        else if secondsDifference > 600 && secondsDifference < 3600  {
            let minutes:Int64 = secondsDifference / 60
            postedTime  = "\(minutes) minutes ago"
        }
        
        else if secondsDifference > 3600 && secondsDifference < 86400 {
            let hours:Int64 = secondsDifference / 3600
            postedTime  = "\(hours) hours ago"
        }
        else{
            let days:Int64 = secondsDifference / 86400
            postedTime  = "\(days) days ago"
        }
        
        return postedTime
        
    }
    
}

