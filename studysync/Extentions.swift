//
//  Extentions.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/14/25.
//

import Foundation
import UIKit

//create an extentions for all the strings to check if the string is blank or not
extension Optional where Wrapped == String{
    var isBlank : Bool {
        guard let notNilBool = self else{
            return true
        }
        
        //at this point we know the optional value is not null, we can now check the blank spaces
        return notNilBool.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidEmail : Bool {
        guard let notNilEmail = self else{
            return false
        }
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension String {
    var isValidString : Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension UIViewController {
    func showErrorMessage (title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    //this is a function with trailing closure so that we can execute a code when a user creates a OK button
    func showErrorMessageWithClosure (title: String, message: String, onComplete: (()-> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let onCompleteAction:UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action in
            onComplete?()
        }
        alert.addAction(onCompleteAction)
        present(alert, animated: true, completion: nil)
    }
}
