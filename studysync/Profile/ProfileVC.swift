//
//  ProfileVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/2/25.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var editProfileIcon: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var accountManagementOptionIcon: UIImageView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileIcon.addTapGestureRecognizer {
            print("Image Tapped")
            self.performSegue(withIdentifier: "editProfileSegue", sender: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the navigation controller in this screen
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //show the navigagtion controller in other screens
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
//    @objc func editProfileTap (tapGestureRecogniser: UITapGestureRecognizer){
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
