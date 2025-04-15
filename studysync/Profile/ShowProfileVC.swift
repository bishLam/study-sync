//
//  ShowProfileVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/5/25.
//

import UIKit

class ShowProfileVC: UIViewController {
    //we will receive the current user from the previous page as it will be easier than to fetch the user in every pages
    var currentUser : User!
    
    //iboutlets from the storyboard
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImageView.setLocalImage(imageName: currentUser.pictureName)
        userFullNameLabel.text = currentUser.name
        userEmailLabel.text = currentUser.email
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.destination is EditProfileVC {
            let destinationVC = segue.destination as! EditProfileVC
            destinationVC.currentUser = self.currentUser
        }
    }
    
    @IBAction func unwindToShowProfileVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}
