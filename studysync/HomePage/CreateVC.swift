//
//  CreateVC.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 4/1/25.
//

import UIKit

class CreateVC: UIViewController {

    @IBOutlet weak var createTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextField.layer.borderWidth = 1
        createTextField.layer.cornerRadius = 10
        createTextField.layer.masksToBounds = true
        createTextField.layer.borderColor = UIColor.lightGray.cgColor
        


        // Do any additional setup after loading the view.
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
