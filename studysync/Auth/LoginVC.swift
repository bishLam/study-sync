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
    
    //spinner while verifying the data
    let spinner = UIActivityIndicatorView(style: .large)
    
    
    //repository for the app
    var repository = Repository()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.color = .black
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        
        signupButton.layer.cornerRadius = 10
//        signupButton.layer.borderWidth = 1
        signupButton.layer.masksToBounds = true
        

    }
    
    @IBAction func loginDidPress(_ sender: UIButton) {
        //here we can check if the login details has been filled by the user or not
        
        //set the spinner to loading
        self.view.addSubview(spinner)
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        //check if all the values has been passed in and are in correct format by the user
        guard !emailTextField.text.isBlank && emailTextField.text.isValidEmail
        , let email = emailTextField.text
        else{
            self.stopSpinner()
            showErrorMessage(title: "Error", message: "Email is not provided in correct format")
            return
        }
        
        guard !passwordTextField.text.isBlank, let password = passwordTextField.text else{
            self.stopSpinner()
            showErrorMessage(title: "Error", message: "Password cannot be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, error in
            guard error == nil else{
                self.stopSpinner()
                self.showErrorMessage(title: "Error", message: "\(error!.localizedDescription)")
                return
            }
            
            //verify if the email confirmation has been finished
            guard Auth.auth().currentUser?.isEmailVerified == true else{
                self.stopSpinner()
                self.showErrorMessage(title: "Pending error verification", message: "We have sent you an email to verify your account. Please verify your email before logging in")
                return
            }
            
            //here we need to navigate to another view controller through code
            let HomeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
            self.view.window?.rootViewController = HomeVC
            self.view.window?.makeKeyAndVisible()
            
            
            self.stopSpinner()

            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the view in this VC
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //show the nav bar in others
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    
    func stopSpinner (){
        self.view.isUserInteractionEnabled = true
        self.spinner.stopAnimating()
    }

}
