//
//  CreateVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateVC: UIViewController {
    
    var service = Repository()
    var currentUser: User!

    @IBOutlet weak var createTextField: UITextView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //decorate the text field
        createTextField.layer.borderWidth = 1
        createTextField.layer.cornerRadius = 10
        createTextField.layer.masksToBounds = true
        createTextField.layer.borderColor = UIColor.lightGray.cgColor
        

        // if there is no current user get one and show the data
        if currentUser == nil {
            Repository().findUserByEmail(email: Auth.auth().currentUser?.email ?? "") { user, error in
                if !error {
                    self.currentUser = user
                    if user?.pictureName != nil && user?.pictureName != "" {
                        self.profilePictureImageView.image = UIImage(named: user!.pictureName)
                        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.width / 2
                    }
                    
                }
                else{
                    return
                }
            }
        }
        
        if currentUser?.pictureName != nil && currentUser?.pictureName != "" {
            self.profilePictureImageView.image = UIImage(named: currentUser!.pictureName)
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.width / 2
        }
        userNameLabel.text = currentUser.name
        userRoleLabel.text = currentUser.role
        
        

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        self.service.createNewPostByUser(user: currentUser, post: Post(description: createTextField.text, postedTime: Timestamp(date: Date()), userId: currentUser.userID)) { success, error in
            if success{
                self.showErrorMessage(title: "Success", message: "Your post has been created successfully")
            }
            
            else if !success {
                self.showErrorMessage(title: "Error", message: "Something went wrong. Please try again later.")
            }
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(createTextField.text == nil || createTextField.text == ""){
            
            createTextField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        
        else{
           
            return true
            
        }
        
    }
  

}
