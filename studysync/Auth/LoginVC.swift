//
//  LoginVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/14/25.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    //here we will define all the UI components
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    //repository for the app
    var repository = Repository()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupButton.layer.cornerRadius = 10
//        signupButton.layer.borderWidth = 1
        signupButton.layer.masksToBounds = true
        

    }
    
    @IBAction func loginDidPress(_ sender: UIButton) {
        //here we can check if the login details has been filled by the user or not
        
        //check if all the values has been passed in and are in correct format by the user
        guard !emailTextField.text.isBlank && emailTextField.text.isValidEmail
        , let email = emailTextField.text
        else{
            showErrorMessage(title: "Error", message: "Email is not provided in correct format")
            return
        }
        
        guard !passwordTextField.text.isBlank, let password = passwordTextField.text else{
            showErrorMessage(title: "Error", message: "Password cannot be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, error in
            guard error == nil else{
                self.showErrorMessage(title: "Error", message: "\(error!.localizedDescription)")
                return
            }
            
            //verify if the email confirmation has been finished
            guard Auth.auth().currentUser?.isEmailVerified == true else{
                self.showErrorMessage(title: "Pending error verification", message: "We have sent you an email to verify your account. Please verify your email before logging in")
                return
            }
            
            //here we need to navigate to another view controller through code
            let HomeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
            self.view.window?.rootViewController = HomeVC
            self.view.window?.makeKeyAndVisible()
            
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the view in this VC
        self.navigationController?.tabBarController?.isTabBarHidden = true
    }
    
    
    
    @IBOutlet weak var forgotPasswordDidPress: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
