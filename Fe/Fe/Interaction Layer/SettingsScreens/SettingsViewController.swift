//
//  SettingsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: SettingsViewController : UIViewController
 - Description: Holds logic for the Main Settings Screen
 -----------------------------------------------------------------------*/
class SettingsViewController: UIViewController {
    let settingsLogic = SettingsViewLogic()
    // UI Variables
    @IBOutlet var txtDoctorPhone: UITextField!
    @IBOutlet var txtEmergencyName: UITextField!
    @IBOutlet var txtEmergencyPhone: UITextField!
    

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEmergencyContactData()
        
        view.backgroundColor = .white
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutButtonTapped))
        
        // Tap Gesture to close the onscreen keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    /*--------------------------------------------------------------------
     - Function: prepare()
     - Description: Prepare any code before changing scenes.
     -------------------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    /*--------------------------------------------------------------------
     - Function: logOutButtonTapped()
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
     - Function: updateEmergencyBtnTapped()
     - Description: updates Emergency contact information.
     -------------------------------------------------------------------*/
    @IBAction func updateEmergencyBtnTapped(_ sender: Any) {
        // Get values from Text boxes
        let doctorPhone = txtDoctorPhone.text ?? ""
        let emergencyName = txtEmergencyName.text ?? ""
        let emergencyPhone = txtEmergencyPhone.text ?? ""

        settingsLogic.updateEmergencyContact(doctorPhone : doctorPhone, emergencyName : emergencyName, emergencyPhone : emergencyPhone, completion: {success in
                var msg = ""
                if success {
                    msg = "Successfully updated emergency contact details"
                } else {
                    msg = "Update Not Successful"
                }
                let updateAlert = UIAlertController(title: "Updating Data", message: msg, preferredStyle: UIAlertController.Style.alert)
                updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(updateAlert, animated: true, completion: nil)
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: getEmergencyContactData()
     - Description: Fetches emergency contact data from firestore and
     fills values in text boxes
     -------------------------------------------------------------------*/
    private func getEmergencyContactData() {
        settingsLogic.getEmergencyContactData(completion: {
            userData in
            self.txtDoctorPhone.text = userData["doctorPhone"]
            self.txtEmergencyName.text = userData["emergencyName"]
            self.txtEmergencyPhone.text = userData["emergencyPhone"]
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: editAccountBtnTapped()
     - Description: Changes Screen to Edit Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func editAccountBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEditUserSettings", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: notificationSettingsBtnTapped()
     - Description: Changes Screen to Notification Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func notificationSettingsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToNotificationSettings", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: appPermissionsBtnTapped()
     - Description: Changes Screen to Application Settings Screen.
     -------------------------------------------------------------------*/
    @IBAction func appPermissionsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAppPermissions", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: deleteDataBtnTapped()
     - Description: Prompt to delete all your data
     -------------------------------------------------------------------*/
    @IBAction func deleteDataBtnTapped(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Delete Data", style: .destructive ) { action in
            do {
                // Delete Data
                self.settingsLogic.deleteFBSensorData()
//                self.deleteSensorData()
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
     - Function: deleteAccountBtnTapped()
     - Description: Prompt to delete account and redirects to Start Screen.
     -------------------------------------------------------------------*/
    @IBAction func deleteAccountBtnTapped(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive ) { action in
            do {
                // Show Prompt for deleting or keeping data
                self.deleteDataPrompt()
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
     - Function: deleteDataPrompt()
     - Description: Ask if user wants to delete data too.
     -------------------------------------------------------------------*/
    func deleteDataPrompt() {
        let deleteAllAction = UIAlertAction(title: "Delete All", style: .destructive ) { action in
            do {
                self.settingsLogic.deleteFBData()
                self.settingsLogic.deleteAccount()
            }
        }
        let deleteAccountOnlyAction = UIAlertAction(title: "Delete Account, Keep Data", style: .destructive ) { action in
            do {
                self.settingsLogic.deleteAccount()
//                self.deleteAccount()
            }
        }
        //Leaving this logic in VC as it is just interaction logic
        let msg = "Do you want to delete your data and account?"
        let deleteDataAlert = UIAlertController(title: "Delete Data", message: msg, preferredStyle: UIAlertController.Style.alert)
        deleteDataAlert.addAction(deleteAllAction)
        deleteDataAlert.addAction(deleteAccountOnlyAction)
        deleteDataAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteDataAlert, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     - Function: deleteAccount()
     - Description: Logic to delete account from Firestore.
     -------------------------------------------------------------------*/
    func deleteAccount() {
        settingsLogic.deleteAccount()
        // Redirect the user to the StartViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartScreen") as! StartViewController
        startViewController.modalPresentationStyle = .fullScreen
        self.present(startViewController, animated:true, completion:nil)
    }
    

}
