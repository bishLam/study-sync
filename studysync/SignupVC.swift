//
//  SignupVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/14/25.
//

import UIKit
import FirebaseAuth

class SignupVC: UIViewController {
    //textfields and buttons from Ui
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var uniEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //this is the function that will be executed when we want to go back to login page
    func redirectToLoginClosure () -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonDidPress(_ sender: UIButton) {
        redirectToLoginClosure()
    }
    
    @IBAction func signinButtonDidPress(_ sender: UIButton) {
        redirectToLoginClosure()
    }
    
    
    
    @IBAction func signUpButtonDidPress(_ sender: UIButton) {
        //check if all the values has been passed in and are in correct format by the user
        guard !uniEmailTextField.text.isBlank && uniEmailTextField.text.isValidEmail, let email = uniEmailTextField.text else{
            showErrorMessage(title: "Error", message: "Please make sure to provide valid email address")
            return
        }
        
        guard !fullNameTextField.text.isBlank, let fullName = fullNameTextField.text else{
            showErrorMessage(title: "Error", message: "Full name cannot be empty ")
            return
        }
        guard !passwordTextField.text.isBlank else{
            showErrorMessage(title: "Error", message: "Password cannot be empty")
            return
        }
        
        guard let password = passwordTextField.text else {return}
        if password.count < 6 {
            showErrorMessage(title: "Error", message: "Passwords must be at least 6 characters long")
            return
        }
        
        if(passwordTextField.text != repeatPasswordTextField.text){
            showErrorMessage(title: "Unmatched Passwords", message: "Please make sure to enter both of the passwords correctly")
        }
        

        
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            guard error == nil else{
                self.showErrorMessage(title: "Error", message: "Something went wrong while signing you up. Please check out the error below for more information. \n \(error!.localizedDescription)")
                return
            }
            print(authResult!.user)
            
            //send email confirmation and get it verified
            Auth.auth().currentUser?.sendEmailVerification() { error in
                guard error == nil else{
                    self.showErrorMessage(title: "Something went wrong", message: "\(error!.localizedDescription)")
                    return
                }
                
                self.showErrorMessageWithClosure(title: "Email Confirmation", message: "A confirmation email has been sent to your email address. Please check your inbox and follow the instructions to verify your email address.") {
                    self.redirectToLoginClosure()
                }
            }
            
        }
        
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
