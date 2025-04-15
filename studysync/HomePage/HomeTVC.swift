//
//  HomeTVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/29/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeTVC: UITableViewController {
    
    var userPosts = [Post]()
    var service = Repository()
    var currentUserID = Auth.auth().currentUser?.email ?? ""
    @IBOutlet weak var connectedCollegeLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet var postsTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topProfileImageView: UIImageView!
    
    var selectedPost: Post!
    var currentUser: User!
    
    let spinner = UIActivityIndicatorView(style: .large)

    
    //this variable are to send the value into the next screen when we press on each of the post

    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.color = .black
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true

        // spinner when the view is loading with the data
        spinner.startAnimating()
        self.view.addSubview(spinner)
        self.view.isUserInteractionEnabled = false
        
        service.findUserByEmail(email: currentUserID) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            self.currentUser = user
            self.welcomeLabel.text = "Welcome \(user.name)"
            self.connectedCollegeLabel.text = "You are connected to \(user.university)"
            
            //for the image
            if user.pictureName != ""{
                self.profileImageView.image = UIImage(named: user.pictureName)
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                self.topProfileImageView.image = UIImage(named: user.pictureName)
                self.topProfileImageView.layer.cornerRadius = self.topProfileImageView.frame.size.width / 2
            }
            
            self.service.getUserUniversityByReference(universityReference: user.university) { university, error in
                guard let university = university else{
                    print("No university found");
                    return
            }
                self.connectedCollegeLabel.text = "You are connected with \(university.universityName)"
            }
        }
        
        service.listAllPostsByUser(userID: currentUserID) { posts, error in
            if !error {
                guard let posts = posts else{
                    print("No posts found for the current user")
                    return
                }
                
                self.userPosts = posts
                self.postsTableView.reloadData()
                self.view.isUserInteractionEnabled = true
                self.spinner.stopAnimating()
            }
        }
        
        topProfileImageView.addTapGestureRecognizer {
//            let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
            self.tabBarController?.selectedIndex = 2
//            self.performSegue(withIdentifier: "editProfileSegue", sender: AccountVC())
//            self.navigationController?.pushViewController(accountVC, animated: true)
            
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userPosts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPagePostsIdentifier", for: indexPath) as! PostsTVCell

        // Configure the cell...
        let post = userPosts[indexPath.row]
        
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
            
            if likes == nil{
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
        
        //display poster full name
        service.findUserByEmail(email: post.userId) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            cell.posterNameLabel.text = user.name
            cell.roleLabel.text = user.role
            if user.pictureName != "" {
                cell.posterImage.image = UIImage(named: user.pictureName)
                cell.posterImage.layer.cornerRadius = cell.posterImage.frame.width / 2
            }
        }
        cell.questionLabel.text = post.description //displays the description
        cell.timeLabel.text = post.setTimeFormat()

        self.service.hasUserLikedThePost(postID: post.postID, userRef: self.currentUser.university, userID: self.currentUser.userID) { hasLiked, error in
            
            guard error == nil else{
                print("Error : \(error)")
                return
            }
            
            if hasLiked{
                cell.likeButton.image = UIImage(systemName: "arrowshape.up.fill")
            }
            else {
                cell.likeButton.image = UIImage(systemName: "arrowshape.up")
            }
        }
        
        cell.likesStackView.addTapGestureRecognizer {
            self.service.toggleLikeInAPost(postID: post.postID, userRef: self.currentUser.university, userID: self.currentUser.userID) { success, status,  error in
                if success {
                    if status == "added"{
//                            cell.likeButton.image = UIImage(systemName: "arrowshape.up.fill")
                        print("like added")
                        
                    }
                    
                    else if status == "removed" {
//                            cell.likeButton.image = UIImage(systemName: "arrowshape.up")
                        print("like removed")
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
    
    
    //This is to show the context menu when pressed on the rows
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let currentPost = userPosts[indexPath.row];
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: {
                suggestedActions in
                
                let addToFavouriteAction = UIAction(title: "Add to favourites", image: UIImage(systemName: "plus.square.on.square")) {action in
                    //add to favourites list here
                    print("on favourites added")
                }
                
                let deleteAction = UIAction(title:"Delete Post", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    // do something when delete button is pressed
                    
                    
                    //confirm tapped mean
                    let alertPopup = UIAlertController(title: "Are you sure you want to delete this post?", message: "This post will permanently be deleted from the database so you will have no access to this afterwards", preferredStyle: .alert)
                    
                    let confirmDelete = UIAlertAction(title: "Yes, Delete for me",
                                              style: .destructive) { action in
                        self.service.deletePost(postID: currentPost.postID, userRef: self.currentUser.university) { success, error in
                            guard error == nil else{
                                self.showErrorMessage(title: "Error", message: "Sorry we could not delete the post because of the following reason. \n \(error?.localizedDescription ?? "no description")")
                                return
                            }
                            self.showErrorMessage(title: "Deleted Successfully", message: "Your post has successfully been deleted.")
                        }
                    }
                    let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    alertPopup.addAction(confirmDelete)
                    alertPopup.addAction(cancelDelete)
                    self.present(alertPopup, animated: true)
                    
                    
                }
                
                if currentPost.userId == self.currentUserID{
                    return UIMenu(title: "", children: [addToFavouriteAction, deleteAction])
                }
                else{
                    return UIMenu(title: "", children: [addToFavouriteAction])
                }
                
                
            }
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the navigation controller on this screen
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //show the navigation controller in other screens
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedPost = userPosts[indexPath.row]
        print("selected post: \(indexPath.row)")
        return indexPath
    }
    


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
            // Create a new instance of the eappropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }e
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
        
        if segue.identifier == "goToCommentsSegue" {
            let destinationVC = segue.destination as? CommentsTVC
            
            destinationVC?.receivedPost = self.selectedPost
            destinationVC?.currentUser = self.currentUser
        }
        
        else if segue.identifier == "goToCreatePage" {
            let destinationVC = segue.destination as? CreateVC
            destinationVC?.currentUser = self.currentUser
        }
        }
    
    @IBAction func unwindToHomeTVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? CreateVC
        // Use data from the view controller which initiated the unwind segue
    }


}
