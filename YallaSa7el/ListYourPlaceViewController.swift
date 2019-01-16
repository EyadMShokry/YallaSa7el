//
//  ListYourPlaceViewController.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/13/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class ListYourPlaceViewController: UIViewController {
    
    
    // MARK: - UI Elements and variables
    
    @IBOutlet weak var apartementImageView: UIImageView!
    @IBOutlet weak var apartementTitle: UITextField!
    @IBOutlet weak var apartementAddress: UITextField!
    @IBOutlet weak var apartementDistrict: UITextField!
    @IBOutlet weak var apartementPricePerNight: UITextField!
    @IBOutlet weak var numberOfRoomsPickerView: UIPickerView!
    @IBOutlet weak var numberOfBathroomsPickerView: UIPickerView!
    let roomsNum = [1,2,3,4,5,6,7,8,9,10]
    let bathroomsNum = [1,2,3,4]
    
    
    // MARK: - View Appearing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apartementPricePerNight.delegate = self
        setPickerViewDelegateAndDataSource(pickerView: numberOfRoomsPickerView)
        setPickerViewDelegateAndDataSource(pickerView: numberOfBathroomsPickerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    
    // MARK: - Savind Data
    
    fileprivate func resetUIElements() {
        apartementImageView.image = #imageLiteral(resourceName: "load_image")
        apartementTitle.text = ""
        apartementAddress.text = ""
        apartementDistrict.text = ""
        apartementPricePerNight.text = ""
    }
    
    fileprivate func fillingNewApartementData(_ newApartement: Apartement) {
        if(apartementImageView.image != #imageLiteral(resourceName: "load_image")){
            newApartement.apartementImage = apartementImageView.image
        }
        newApartement.apartementTitle = apartementTitle.text
        newApartement.apartementAddress = apartementAddress.text
        newApartement.apartementDistrict = apartementDistrict.text
        newApartement.oneNightPrice = apartementPricePerNight.text
        newApartement.numberOfRooms = Int16(numberOfRoomsPickerView.selectedRow(inComponent: 0) + 1)
        newApartement.numberOfBathrooms = Int16(numberOfBathroomsPickerView.selectedRow(inComponent: 0) + 1)
        newApartement.additionDate = NSDate() as Date
    }
    
    fileprivate func allFieldsFilled() -> Bool {
        if apartementImageView.image == #imageLiteral(resourceName: "load_image") || apartementTitle.text == "" || apartementAddress.text == "" || apartementDistrict.text == "" || apartementPricePerNight.text == "" {
            return false
        }
        return true
    }
    
    fileprivate func raiseAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defualtAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defualtAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if(allFieldsFilled()){
            let newApartement = Apartement(context: context)
            fillingNewApartementData(newApartement)
            appDelegate.saveContext()
            resetUIElements()
            raiseAlertController(title: "Success", message: "Your Apartement has been added successfully, Thanks!")
        }
        else {
            raiseAlertController(title: "Error", message: "Please fill all the fields!")
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
        return keyboardSize.cgRectValue.height
    }
    
}


// MARK: - Picker Views Implementation

extension ListYourPlaceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setPickerViewDelegateAndDataSource(pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return roomsNum.count
        } else {
            return bathroomsNum.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(roomsNum[row])
        } else {
            return String(bathroomsNum[row])
        }
    }

}


// MARK: - Image PickerController Implementation

extension ListYourPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addApartementImageBtnClicked(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            apartementImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}


// MARK: - Price TextField Validation

extension ListYourPlaceViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == apartementPricePerNight {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
