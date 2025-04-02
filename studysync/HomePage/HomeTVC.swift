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
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        service.findUserByEmail(email: currentUserID) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            self.welcomeLabel.text = "Welcome \(user.name)"
        }
        
        
        service.listAllPostsByUser(userID: currentUserID) { posts, error in
            if !error {
                guard let posts = posts else{
                    print("No posts found for the current user")
                    return
                }
                
                self.userPosts = posts
                self.postsTableView.reloadData()
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
        return userPosts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPagePostsIdentifier", for: indexPath) as! PostsTVCell

        // Configure the cell...
        let post = userPosts[indexPath.row]
        //display poster full name
        var posterName = "Unknown"
        var posterRole = "Unknown"
        service.findUserByEmail(email: post.userId) { user, success in
            guard let user = user else{
                print("No user found")
                return
            }
            posterName = user.name
            posterRole = user.role
            cell.posterNameLabel.text = posterName
            cell.roleLabel.text = posterRole
        }

        cell.questionLabel.text = post.description //displays the description
        let timeText:String
        let currentTime = Timestamp(date: Date())
        let secondsDifference = currentTime.seconds - post.postedTime.seconds
        
        //display just now for the first 10 minutes of posting
        if secondsDifference < 600 {
            timeText = "Just Now"
        }
        
        else if secondsDifference > 600 && secondsDifference < 3600  {
            let minutes:Int64 = secondsDifference / 60
            timeText = "\(minutes) minutes ago"
        }
        
        else if secondsDifference > 3600 && secondsDifference < 86400 {
            let hours:Int64 = secondsDifference / 3600
            timeText = "\(hours) days ago"
        }
        else{
            let days:Int64 = secondsDifference / 86400
            timeText = "\(days) days ago"
        }
        
        
        //displays the time text accordingly
        cell.timeLabel.text = timeText
        

        return cell
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        //set navigation
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
