//
//  ProfileVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/2/25.
//

import UIKit
import FirebaseAuth

class AccountVC: UIViewController {
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
            self.performSegue(withIdentifier: "editProfileSegue", sender: self)
        }
        
        //logout user when pressed
        logoutLabel.isUserInteractionEnabled = true
        logoutIcon.isUserInteractionEnabled = true
        logoutLabel.addTapGestureRecognizer {
            self.logout()
            
        }
        logoutIcon.addTapGestureRecognizer {
            self.logout()
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
    
    func logout() -> Void {
        do {
            try Auth.auth().signOut();
            let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? UIViewController
            self.view.window?.rootViewController = loginVC
            self.view.window?.makeKeyAndVisible()
            
        }
        catch let signoutError as NSError{
            showErrorMessage(title: "Error", message: "We could not sign you out at this time. Please try again later. \(signoutError.localizedDescription)")
        }
    }

}
