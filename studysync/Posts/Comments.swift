//
//  Comments.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/4/25.
//

import Foundation

class Comment {
    var commentID: String!
    var commentText: String
    var commenterEmail: String
    

    
     init(commentText: String, commenterEmail: String) {
        self.commentText = commentText
        self.commenterEmail = commenterEmail
    }
    
    convenience init(commentID: String, commentText: String, commenterEmail: String) {
        
        self.init(commentText: commentText, commenterEmail: commenterEmail)
        self.commentID = commentID
        
    }
    
    convenience init(commentID:String, dictionary: [String:Any]){
        self.init(commentText: dictionary["commentText"] as? String ?? "",
                  commenterEmail: dictionary["commenterEmail"] as? String ?? "")
        self.commentID = commentID
    }
    
}

