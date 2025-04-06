//
//  CommentsTVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/4/25.
//

import UIKit

class CommentsTVC: UITableViewController {
    let service = Repository()
    var comments = [Comment]()
    
    //outlets for comments section
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var submitCommentButton: UIButton!
    
    //outlets for post section
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var posterRoleLabel: UILabel!
    
    
    //These variables are for the values passed from segue
    var posterName: String!
    var postedTime: String!
    var posterRole: String!
    var postText:String!
    var postID:String = "YVEpAeSrmXAVMNpYKi7K" //at this point it is not received from segue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        posterNameLabel.text = posterName
//        postedTimeLabel.text = postedTime
//        postDescriptionLabel.text = postText
//        posterRoleLabel.text = posterRole
        
        service.listAllCommentsByPost(postID: postID) { receivedComments, error in
            if let receivedComments = receivedComments{
                self.comments = receivedComments
                print("Total comments: \(self.comments.count)")
                self.comments.count > 0 ? (self.noCommentsLabel.isHidden = true) : (self.noCommentsLabel.isHidden = false)
                self.commentsTableView.reloadData()
            }
        }
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

        // Configure the cell...
        let comment = comments[indexPath.row]
        
        //get the details about the commenter and set it to the view
        self.service.findUserByEmail(email: comment.commenterEmail) { user, error in
            guard let user = user else {
                return
            }
            
            cell.commenterNameLabel.text = user.name
            cell.commenterRole.text = user.role
            cell.commentsTextLabel.text = comment.commentText
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
    }


}
