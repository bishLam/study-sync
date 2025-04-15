//
//  PostHeaderView.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/14/25.
//



import UIKit

class PostHeaderView: UIView{
    
    //first define all the items inside the view
    let nameLabel = UILabel()
    let roleLabel = UILabel()
    let timeLabel = UILabel()
    let descriptionLabel = UILabel()
    let likeCountLabel = UILabel()
    let commentCountLabel =  UILabel()
    let userImageView = UIImageView()
    let likeImageView = UIImageView()
    let commentImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpViews() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        roleLabel.font = UIFont.italicSystemFont(ofSize: 14)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        likeCountLabel.font = UIFont.systemFont(ofSize: 14)
        commentCountLabel.font = UIFont.systemFont(ofSize: 14)
        
        userImageView.image = UIImage(systemName: "person.circle")
        likeImageView.image  = UIImage(systemName: "hand.thumbsup")
        commentImageView.image = UIImage(systemName: "message")
        
        addSubview(nameLabel)
        addSubview(roleLabel)
        addSubview(timeLabel)
        addSubview(descriptionLabel)
        addSubview(likeCountLabel)
        addSubview(commentCountLabel)
        addSubview(userImageView)
        addSubview(likeImageView)
        addSubview(commentImageView)
    }
    
    private func setUpConstraints() {
        [nameLabel,
         roleLabel,
         timeLabel,
         descriptionLabel,
         likeCountLabel,
         commentCountLabel,
         userImageView,
         likeImageView,
         commentImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false //$0 referes to the first argument os a closure $2 refers to second argument
        }
        
        NSLayoutConstraint.activate([
            //constrains for imageView
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20), //20 away from the top view
            userImageView.heightAnchor.constraint(equalToConstant: 45), //height constraint for imageView
            userImageView.widthAnchor.constraint(equalToConstant: 45), // width constraint for image
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20), //20 away from leading space
            
            
            //constrains for name label
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            
            //constrains for roleLabel
            roleLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            likeImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            likeImageView.widthAnchor.constraint(equalToConstant: 20),
            likeImageView.heightAnchor.constraint(equalToConstant: 20),
            
            likeCountLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: 6),
            
            commentImageView.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 16),
            commentImageView.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor),
            commentImageView.widthAnchor.constraint(equalToConstant: 20),
            commentImageView.heightAnchor.constraint(equalToConstant: 20),
            
            commentCountLabel.centerYAnchor.constraint(equalTo: commentImageView.centerYAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 6),
            
            commentCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
            
        ])
    }
    
    
    func configure(with post: Post, user: User, likeCount: Int, commentCount:Int) {
        nameLabel.text = user.name
        roleLabel.text = user.role
        timeLabel.text = post.setTimeFormat()
        descriptionLabel.text = post.description
        likeCountLabel.text = "\(likeCount)"
        commentCountLabel.text = "\(commentCount)"
    }

}
