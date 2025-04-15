//
//  CommentsTVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/4/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommentsTVC: UITableViewController {
    let service = Repository()
    var comments = [Comment]()
    var currentUser:User!
    var currentUserID = Auth.auth().currentUser?.email!
    
    //These variables are for the values received from segue
    var receivedPost: Post!
    
    //outlets for comments section
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var submitCommentButton: UIButton!

    
    //outlets for post section
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var posterRoleLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likeStackView: UIStackView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var upVoteImageView: UIImageView!
    
    //on submitting comment
    @IBAction func submitCommentButtonDidPress(_ sender: Any) {
        self.newCommentTextField.becomeFirstResponder()
        print(newCommentTextField.text ?? "")
        
        let newComment = newCommentTextField.text
        
        if(newComment == nil || newComment.isBlank){
            
            return
        }
        let comment = Comment(commentText: newComment!, commenterEmail: currentUser.email, commentTime: Timestamp(date: Date()))
        
        service.addNewCommentInAPost(user: currentUser, postID: receivedPost.postID, comment: comment) { success, error in
            guard error == nil else{
                self.showErrorMessage(title: "Error", message: "\(String(error!.localizedDescription))")
                return
            }
            self.newCommentTextField.text = ""
            self.newCommentTextField.resignFirstResponder()
        }
        
    }

    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad();

        if currentUser == nil {
            service.findUserByEmail(email: currentUserID!) { user, success in
                guard let user = user else{
                    print("No user found")
                    return
                }
                self.currentUser = user
                self.updateUI( posterUser: self.receivedPost.userId, currentUser:user)

            }
        }
        else{
            updateUI(posterUser: receivedPost.userId, currentUser:currentUser)
        }
        
        likeStackView.addTapGestureRecognizer {
            self.service.toggleLikeInAPost(postID: self.receivedPost.postID, userRef: self.currentUser.university, userID: self.currentUser.userID) { success, status,  error in
                if success {
                    return
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        //shows the liked button if it is liked or empty if it's not

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsIdentifier", for: indexPath) as! CommentsTableViewCell
        //get the current comment
        let comment = comments[indexPath.row]
        //commenterdetails
        self.service.findUserByEmail(email: comment.commenterEmail) { user, error in
            guard let user = user else {
                return
            }
            
            cell.commenterNameLabel.text = "\(user.name) (\(user.role))"
            if user.pictureName != "" {
                cell.commenterImage.image = UIImage(named: user.pictureName)
                cell.commenterImage.layer.cornerRadius = self.posterImageView.frame.height / 2
            }
            cell.commenterRole.text = comment.setTimeFormat()
            cell.commentsTextLabel.text = comment.commentText
            
            self.service.getTotalLikesInAComment(postID: self.receivedPost.postID, commentID: comment.commentID, userRef: self.currentUser.university) { likeCount, error in
                if error != nil {
                    cell.totalCommentLikes.text = "0"
                    return
                }
                guard let count = likeCount else{
                    cell.totalCommentLikes.text = "0"
                    return
                }
                cell.totalCommentLikes.text = "\(count)"
            }
            
            cell.likeStackView.addTapGestureRecognizer {
                self.service.toggleLikeInAComment(postID: self.receivedPost.postID, commentID: comment.commentID, currentUser: self.currentUser) { success, error in
                    guard error == nil else{
                        return
                    }
                    if success{
                        
                    }
                }
            }
            
            self.service.hasUserLikedTheComment(postID: self.receivedPost.postID, commentID: comment.commentID, currentUser: self.currentUser) { hasLiked, error in
                guard error == nil else{
                    print("\(error?.localizedDescription)")
                    return
                }
                if hasLiked{
                    cell.likeImageView.image = UIImage(systemName: "arrowshape.up.fill")
                }
                else{
                    cell.likeImageView.image = UIImage(systemName: "arrowshape.up")
                }
                
            }

        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func updateUI(posterUser:String, currentUser:User){
        
        
        //place the view on top of the tableView
//        let postHeaderView  = PostHeaderView()
//        postHeaderView.translatesAutoresizingMaskIntoConstraints = false
//        var  postUser:User!

        //insert user details
        service.findUserByEmail(email: posterUser) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }

//            postUser = user
            self.posterNameLabel.text = user.name
            self.posterRoleLabel.text = user.role
            
            if user.pictureName != "" {
                self.posterImageView.image = UIImage(named: user.pictureName)
                self.posterImageView.layer.cornerRadius = self.posterImageView.frame.height / 2
            }
            
        }
        

        postedTimeLabel.text = receivedPost.setTimeFormat()
        postDescriptionLabel.text = receivedPost.description
        
        
//        //set up the height of the view
//        let lines = self.calculateNumberOfLines(for: postDescriptionLabel)
//        let height = lines * 20 + 100
//        self.postContainerView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
//        print("height: \(height)")
        
        
        //show total likes
        service.getLikesInAPost(postID: receivedPost.postID, userRef: currentUser.university) { likes, error in
            guard error == nil else{
                //                print("no liked found 1")
                return
            }
            guard likes == likes else{
                //                print("no liked found")
                return
            }
            if likes == nil {
                self.likesCountLabel.text = "0"
            }
            else{
                self.likesCountLabel.text = "\(likes!.count)"
            }
//            totalLikes = likes!.count
            
            
            self.service.hasUserLikedThePost(postID: self.receivedPost.postID, userRef: self.currentUser.university, userID: self.currentUser.email) { hasLiked, error in
                guard error == nil else{
                    return
                }
                if hasLiked{
                    self.upVoteImageView.image = UIImage(systemName: "arrowshape.up.fill")
                    return
                }
                else{
                    self.upVoteImageView.image = UIImage(systemName: "arrowshape.up")
                    return
                }
            }
            //show total comments in a post and list them
            self.service.listAllCommentsByPost(postID: self.receivedPost.postID) { receivedComments, error in
                
                if let receivedComments = receivedComments{
                    self.comments = receivedComments
                    //                print("Total comments: \(self.comments.count)")
                    self.comments.count > 0 ? (self.noCommentsLabel.isHidden = true) : (self.noCommentsLabel.isHidden = false)
                    self.commentsCountLabel.text = "\(receivedComments.count)"
                    self.commentsTableView.reloadData()}
            }
            
            //                    totalComments = receivedComments.count
            
            
            //                    //set up the header view
            //                    let postHeaderView = PostHeaderView()
            //                    postHeaderView.translatesAutoresizingMaskIntoConstraints = false
            ////                    postHeaderView.configure(with: self.receivedPost, user: postUser, likeCount: totalLikes, commentCount: totalComments)
            //
            //                    //now we use auto layout to size the view
            //                    let targetSize = CGSize(width: self.tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
            //                    let fittingSize = postHeaderView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            //
            //                    postHeaderView.frame = CGRect(origin: .zero, size: fittingSize)
            //                    self.tableView.tableHeaderView = postHeaderView
            
        }

        
        
        
        

        
        
    }
    
    
    func calculateNumberOfLines(for label: UILabel) -> Int {
        guard let text = label.text, let font = label.font else { return 0 }
        
        let maxWidth = label.frame.width
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let textSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingRect = (text as NSString).boundingRect(
            with: textSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: textAttributes,
            context: nil
        )
        
        let lineHeight = font.lineHeight
        let numberOfLines = Int(ceil(boundingRect.height / lineHeight))
        
        return numberOfLines
    }


}
