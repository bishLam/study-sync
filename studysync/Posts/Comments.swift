//
//  Comments.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/4/25.
//

import Foundation
import FirebaseFirestore

class Comment {
    var commentID: String!
    var commentText: String
    var commenterEmail: String
    var commentTime: Timestamp
    

    
     init(commentText: String, commenterEmail: String, commentTime: Timestamp) {
        self.commentText = commentText
        self.commenterEmail = commenterEmail
         self.commentTime = commentTime
    }
    
    convenience init(commentID: String, commentText: String, commenterEmail: String, commentTime: Timestamp) {
        
        self.init(commentText: commentText, commenterEmail: commenterEmail, commentTime: commentTime)
        self.commentID = commentID
        
    }
    
    convenience init(commentID:String, dictionary: [String:Any]){
        self.init(commentText: dictionary["commentText"] as? String ?? "",
                  commenterEmail: dictionary["commenterEmail"] as? String ?? "",
                  commentTime: dictionary["commentTime"] as? Timestamp ?? Timestamp(date: Date())
            )
        self.commentID = commentID
    }
    
    func toDictionary () -> [String: Any]{
        var dictionary: [String:Any] = [:]
        
        dictionary["commentText"] = self.commentText
        dictionary["commenterEmail"] = self.commenterEmail
        dictionary["commentTime"] = self.commentTime
        
        return dictionary
    }
    
    func setTimeFormat() -> String{
        let currentTime = Timestamp(date: Date())
        let secondsDifference = currentTime.seconds - self.commentTime.seconds
        
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

