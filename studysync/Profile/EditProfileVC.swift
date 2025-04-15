//
//  EditProfileVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/2/25.
//

import UIKit

class EditProfileVC: UIViewController {
    var currentUser:User!

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userFullNameTextField: UITextField!
    @IBOutlet weak var userUniversityTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    var initialFullName: String!
    var initialUniversity: String!
    var initialEmail: String!

    
    @IBAction func fullNameTextEdited(_ sender: UITextField) {
        hasTextBeenChanged()
    }
    
    @IBAction func emailTextEdited(_ sender: UITextField) {
        hasTextBeenChanged()
    }
    
    @IBAction func universityTextEdited(_ sender: UITextField) {
        hasTextBeenChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up intial data about the current user
        saveButton.isEnabled = false
        
        userFullNameTextField.text = currentUser.name
        initialFullName = currentUser.name
        userUniversityTextField.text = currentUser.university.path
        initialUniversity = currentUser.university.path
        userEmailTextField.text = currentUser.email
        initialEmail = currentUser.email
        userProfileImageView.setLocalImage(imageName: currentUser.pictureName)
    }
    
    func hasTextBeenChanged(){
        
        if initialFullName != userFullNameTextField.text {
            saveButton.isEnabled = true
            return
        }
        
        if initialUniversity != userUniversityTextField.text {
            saveButton.isEnabled = true
            return
        }
        
        if initialEmail != userEmailTextField.text {
            saveButton.isEnabled = true
            return
        }
        saveButton.isEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
