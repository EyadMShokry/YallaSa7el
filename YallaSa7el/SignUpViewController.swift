//
//  SignUpViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/13/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    
    // MARK: - UI Elements
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var agreeConditionsSwitch: UISwitch!
    
    
    // MARK: - UI Configuring
    
    fileprivate func disableTextFields() {
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        usernameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
    }
    
    
    // MARK: - View Appearing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: -  Sign Up Implementation
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        if (emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" || !agreeConditionsSwitch.isOn){
            let alertController = UIAlertController(title: "Error", message: "Please fill all the required fields!", preferredStyle: .alert)
            let defualtAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defualtAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else if (passwordTextField.text != confirmPasswordTextField.text) {
            let alertController = UIAlertController(title: "Error", message: "Password doesn't match!", preferredStyle: .alert)
            let defualtAction = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
            alertController.addAction(defualtAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("Signup successfull")
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController")
                    self.present(viewController!, animated: true, completion: nil)
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defualtAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defualtAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - Configuring view While Keyboard Appearing
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
       if self.view.frame.origin.y == 0 {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
    }
    
    @objc func keyboardWillHide(_ notififcation:Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height - 40
    }

}
