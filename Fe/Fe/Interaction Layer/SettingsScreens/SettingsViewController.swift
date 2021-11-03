//
//  SettingsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: SettingsViewController : UIViewController
 - Description: Holds logic for the Main Settings Screen
 -----------------------------------------------------------------------*/
class SettingsViewController: UIViewController {
    
    // Class Variables
    let settingsLogic = SettingsViewLogic()
    let validation = Validation()
    
    // UI Variables
    @IBOutlet var txtDoctorPhone: UITextField!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDoctorContactData()
        self.setupTextFields()
        
        view.backgroundColor = .white
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutButtonTapped))
        
        // Tap Gesture to close the onscreen keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupTextFields()
     - Description: Set up keyboard for text field.
     -------------------------------------------------------------------*/
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.txtDoctorPhone.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: Selector for finishing keyboard editiing.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: logOutButtonTapped()
     - Description: Creates Prompt and Logs out of Account if selected.
     -------------------------------------------------------------------*/
    @objc func logOutButtonTapped() {
        // Set up log out action and check for errors
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive ) { action in
            self.settingsLogic.logOut()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartScreen") as! StartViewController
            startViewController.modalPresentationStyle = .fullScreen
            self.present(startViewController, animated:true, completion:nil)
        }
        
        // Present the Alert with 2 actions
        let signOutAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        signOutAlert.addAction(logOutAction)
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(signOutAlert, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     //MARK: txtDoctorPhoneFieldChanged()
     - Description: Validate doctor phone number
     -------------------------------------------------------------------*/
    @IBAction func txtDoctorPhoneFieldChanged(_ sender: Any) {
        let phoneNumber = self.txtDoctorPhone.text ?? ""
        let isValid = validation.validatePhoneNumber(phoneNumber: phoneNumber)
        if isValid {
            self.txtDoctorPhone.backgroundColor = .FeValidationGreen
        } else {
            self.txtDoctorPhone.backgroundColor = .FeValidationRed
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateEmergencyBtnTapped()
     - Description: updates Emergency contact information.
     -------------------------------------------------------------------*/
    @IBAction func updateDoctorNumberBtnTapped(_ sender: Any) {
        // If doctor phone number is validated, proceed to update
        if validation.validatePhoneNumber(phoneNumber: txtDoctorPhone.text ?? "") {
            // Get values from Text boxes
            let doctorPhone = txtDoctorPhone.text ?? ""
            
            settingsLogic.updateDoctorContact(doctorPhone: doctorPhone, completion: { success in
                var msg = ""
                if success {
                    msg = "Successfully updated doctor contact details"
                } else {
                    msg = "Update Not Successful"
                }
                let updateAlert = UIAlertController(title: "Updating Data", message: msg, preferredStyle: UIAlertController.Style.alert)
                updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(updateAlert, animated: true, completion: nil)
            })
        } else {
            let msg = "Please verify phone number is 10 digits. Example: 12223334444"
            let updateAlert = UIAlertController(title: "Cannot Update", message: msg, preferredStyle: UIAlertController.Style.alert)
            updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(updateAlert, animated: true, completion: nil)
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: getDoctorContactData()
     - Description: Fetches emergency contact data from firestore and
     fills values in text boxes
     -------------------------------------------------------------------*/
    private func getDoctorContactData() {
        settingsLogic.getDoctorContactData(completion: {
            userData in
            self.txtDoctorPhone.text = userData["doctorPhone"]
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: editAccountDetailsSettingsBtnTapped()
     - Description: Changes Screen to Notification Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func editAccountDetailsSettingsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEditUserSettings", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: notificationSettingsBtnTapped()
     - Description: Changes Screen to Notification Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func notificationSettingsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToNotificationSettings", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: appPermissionsBtnTapped()
     - Description: Changes Screen to Application Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func appPermissionsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAppPermissions", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteDataBtnTapped()
     - Description: Prompt to delete all your data
     -------------------------------------------------------------------*/
    @IBAction func deleteDataBtnTapped(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Delete Data", style: .destructive ) { action in
            do {
                // Delete Data
                let dataDeleted = self.settingsLogic.deleteSensorData()
                
                if dataDeleted {
                    let msg = "Your sensor data has been successfully deleted"
                    let updateAlert = UIAlertController(title: "Deleting Data Successful", message: msg, preferredStyle: UIAlertController.Style.alert)
                    updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(updateAlert, animated: true, completion: nil)
                } else {
                    let msg = "Your sensor data has noot been successfully deleted"
                    let updateAlert = UIAlertController(title: "Deleting Data Failed", message: msg, preferredStyle: UIAlertController.Style.alert)
                    updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(updateAlert, animated: true, completion: nil)
                }
            }
        }
        // Prompt before deleting
        let msg = "Are you sure you want to delete your data?"
        let deleteAccountAlert = UIAlertController(title: "Delete Data", message: msg, preferredStyle: UIAlertController.Style.alert)
            deleteAccountAlert.addAction(deleteAction)
            deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAccountAlert, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAccountBtnTapped()
     - Description: Prompt to delete account and redirects to Start Screen.
     -------------------------------------------------------------------*/
    @IBAction func deleteAccountBtnTapped(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive ) { action in
            do {
                // Try to delete data.
                let dataDeleted = self.settingsLogic.deleteSensorData()
                // If data delete successful, try to delete account
                if dataDeleted {
                    self.settingsLogic.deleteAccount(completion: { success in
                        // If account delete successful, log out
                        if success {
                            let okAction = UIAlertAction(title: "OK", style: .default ) { action in
                                do {
                                    //TODO: STOP TIMER
                                    self.returnToLoginScreen()
                                }
                            }
                            let msg = "Account deleted Successfully"
                            let deleteAccountAlert = UIAlertController(title: "Delete Successful", message: msg, preferredStyle: UIAlertController.Style.alert)
                            deleteAccountAlert.addAction(okAction)
                            self.present(deleteAccountAlert, animated: true, completion: nil)
                            
                        } else {
                            // Error Deleting Account
                            let msg = "There was an error deleting your account. Please try again later."
                            let deleteAccountAlert = UIAlertController(title: "Error Deleting Account", message: msg, preferredStyle: UIAlertController.Style.alert)
                            deleteAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(deleteAccountAlert, animated: true, completion: nil)
                        }
                    })
                } else {
                    // Error Deleting Account
                    let msg = "There was an error deleting your data. Please try again later."
                    let deleteAccountAlert = UIAlertController(title: "Error Deleting Data", message: msg, preferredStyle: UIAlertController.Style.alert)
                    deleteAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(deleteAccountAlert, animated: true, completion: nil)
                }
            }
        }
        // Prompt before deleting
        let msg = "Are you sure you want to delete your account?"
        let deleteAccountAlert = UIAlertController(title: "Delete Account", message: msg, preferredStyle: UIAlertController.Style.alert)
            deleteAccountAlert.addAction(deleteAction)
            deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAccountAlert, animated: true, completion: nil)
    }

    
    /*--------------------------------------------------------------------
     //MARK: returnToLoginScreen()
     - Description: Return user to Login Screen
     -------------------------------------------------------------------*/
    func returnToLoginScreen() {
        // Redirect the user to the StartViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartScreen") as! StartViewController
        startViewController.modalPresentationStyle = .fullScreen
        self.present(startViewController, animated:true, completion:nil)
    }
    

}
