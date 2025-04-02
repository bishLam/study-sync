//
//  PostsTVCell.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/29/25.
//

import UIKit

class PostsTVCell: UITableViewCell {

   //this is like the view holder in android
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentsButton: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    @IBOutlet weak var postContainerView: UIView!
    
    
    
  

}

