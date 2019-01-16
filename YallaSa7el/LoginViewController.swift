//
//  LoginViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/12/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Sign in Implementation
    
    @IBAction func signInBtnClicked(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            if(error == nil){
                print("login successfull")
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController")
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

