//
//  DiscussionsTVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/1/25.
//

import UIKit
import FirebaseAuth

class DiscussionsTVC: UITableViewController {
    let service = Repository()
    let currentUserID = Auth.auth().currentUser?.email ?? ""
    var currentUser: User!
    
    var selectedPost:Post!
    
    @IBOutlet weak var postContainerView: UIView!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.findUserByEmail(email: currentUserID) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            self.currentUser = user
        }
        
        service.listAllPostsByUser(userID: currentUserID) { posts, error in
            if error {
                print("Error fetching posts: \(error)")
                return
            }
            self.posts = posts ?? []
            self.tableView.reloadData()
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPagePostsIdentifier", for: indexPath) as! PostsTVCell

        // Configure the cell...
        
        let post = posts[indexPath.row]
        cell.questionLabel.text = post.description
        cell.timeLabel.text = post.setTimeFormat()

        //find details about the user and set it
        //display poster full name
        service.findUserByEmail(email: post.userId) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            cell.posterNameLabel.text = user.name
            cell.roleLabel.text = user.role
        }
        
        //get totalLikes
        service.getLikesInAPost(postID: post.postID, userRef: currentUser.university) { likes, error in
            guard error == nil else{
                //                print("no liked found 1")
                return
            }
            guard likes == likes else{
                //                print("no liked found")
                return
            }
            
            //likes equals nil means 0 likes in the post
            if likes == nil {
                cell.likeCount.text = "0"
            }
            else{
                cell.likeCount.text = "\(likes!.count)"
            }
            
        }
        
        //getTotalComments
        service.listAllCommentsByPost(postID: post.postID) { receivedComments, error in
            
            if let receivedComments = receivedComments{
                cell.commentsCountLabel.text = "\(receivedComments.count)"
            }
        }
        cell.postContainerView.layer.cornerRadius = 10
        cell.postContainerView.layer.borderColor = UIColor.lightGray.cgColor
        cell.postContainerView.layer.borderWidth = 1
        cell.postContainerView.layer.masksToBounds = true
        
        cell.likesStackView.addTapGestureRecognizer {
            self.service.toggleLikeInAPost(postID: post.postID, userRef: self.currentUser.university, userID: self.currentUser.userID) { success, status,  error in
                if success {
                    if status == "added"{
                        cell.likeButton.image = UIImage(systemName: "arrowshape.up.fill")
                        
                    }
                    
                    else if status == "removed" {
                        cell.likeButton.image = UIImage(systemName: "arrowshape.up")
                    }
                    return
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedPost = posts[indexPath.row]
        return indexPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the navigation view on this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //show the view in othe VC
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    private func headerView() -> UITableViewHeaderFooterView{
//        let view = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
//        view.contentView.backgroundColor = .red
//        let imageView = view.contentView.addSubview(UIImageView(image: UIImage(systemName: "person.circle.fill")))
//        
//        return imageView
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        
        if let commentsViewController = segue.destination as? CommentsTVC {
            print(self.selectedPost.description);
            commentsViewController.receivedPost = self.selectedPost
            
        }
    }


}
