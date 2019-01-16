//
//  ResetPasswordViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/13/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    
    // MARK: - UI Elemets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - Send Reset Mail Implementation
    
    @IBAction func sendResetMailBtnClicked(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
            var title = ""
            var message = ""
            
            if(error != nil) {
                title = "Error!"
                message = (error?.localizedDescription)!
            }
            else {
                title = "Success"
                message = "Password reset email sent"
                self.emailTextField.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defualtAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defualtAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
}
