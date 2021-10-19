//
//  SettingsNotificationPermissionsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-13.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: SettingsNotificationPermissionssViewController : UIViewController
 - Description: Holds logic for the Notification Permissions Screen.
 -----------------------------------------------------------------------*/
class SettingsNotificationPermissionsViewController: UIViewController {
    
    // Class Variables
    let NotificationLogic = NotificationPermissionsLogic()
    let validation = Validation()
    
    // UI Variables
    @IBOutlet var swHRNotification: UISwitch!
    @IBOutlet var swBONotification: UISwitch!
    @IBOutlet var swMedicationReminder: UISwitch!
    @IBOutlet var txtEmergencyName: UITextField!
    @IBOutlet var txtEmergencyPhone: UITextField!
    @IBOutlet var swEmergencyContactState: UISwitch!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Logic to initialize some code before screen loads.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEmergencyContactData()
        self.setupTextFields()
        
        swHRNotification.setOn(NotificationLogic.setSwitchState(key: UserDefaultKeys.swNotificationHRKey.description), animated: false)
        swBONotification.setOn(NotificationLogic.setSwitchState(key: UserDefaultKeys.swNotificationBOKey.description), animated: false)
        swMedicationReminder.setOn(NotificationLogic.setSwitchState(key: UserDefaultKeys.swNotificationMedicationReminderKey.description), animated: false)
        swEmergencyContactState.setOn(NotificationLogic.setSwitchState(key: UserDefaultKeys.swNotifyEmergencyContactKey.description), animated: false)
        
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
        
        self.txtEmergencyName.inputAccessoryView = toolbar
        self.txtEmergencyPhone.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: Selector for finishing keyboard editiing.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: getEmergencyContactData()
     - Description: Fetches emergency contact data from firestore and
     fills values in text boxes
     -------------------------------------------------------------------*/
    private func getEmergencyContactData() {
        NotificationLogic.getEmergencyContactData(completion: {
            userData in
            self.txtEmergencyName.text = userData["emergencyName"]
            self.txtEmergencyPhone.text = userData["emergencyPhone"]
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: swHRSensorStateChanged()
     - Description: Logic for turning on/off heart rate notifications.
     -------------------------------------------------------------------*/
    @IBAction func swHRSensorStateChanged(_ sender: Any) {
        if swHRNotification.isOn {
            print("Notifications for Unusual HR Sensor Activity Switch is on.")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationHRKey.description, value: true)
        } else {
            print("Notifications for Unusual HR Sensor Activity Switch is off.")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationHRKey.description, value: false)
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBOSensorStateChanged()
     - Description: Logic for turning on/off blood oxygen notifications.
     -------------------------------------------------------------------*/
    @IBAction func swBOSensorStateChanged(_ sender: Any) {
        if swBONotification.isOn {
            print("Notifications for Unusual Blood Oxygen Sensor Activity Switch is on.")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationBOKey.description, value: true)
        } else {
            print("Notifications for Unusual Blood Oxygen Sensor Activity Switch is off.")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationBOKey.description, value: false)
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swMedicationReminderStateChanged()
     - Description: Logic for changing notifications for daily medication
     reminder Permission.
     -------------------------------------------------------------------*/
    @IBAction func swMedicationReminderStateChanged(_ sender: Any) {
        if swMedicationReminder.isOn {
            print("Med Reminder On - Scheduled task")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: true)
            NotificationLogic.scheduleMedicationReminder()
        } else {
            print("Med Reminder Off - Removed all tasks")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: false)
            NotificationLogic.cancelAllScheduledNotifications()
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swEmergencyContactStateChanged()
     - Description: Logic for changing state of emergency contact button.
     -------------------------------------------------------------------*/
    @IBAction func swEmergencyContactStateChanged(_ sender: Any) {
        if swEmergencyContactState.isOn {
            print("Text to Emergency Contact On")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: true)
        } else {
            print("Text to Emergency Contact Off")
            NotificationLogic.updateSwitchState(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: false)
        }
    }
    
    
    /*--------------------------------------------------------------------
     //MARK: updateEmergencyBtnTapped()
     - Description: Updates Emergency Contact Entries.
     -------------------------------------------------------------------*/
    @IBAction func updateEmergencyBtnTapped(_ sender: Any) {
        
        
        // Get values from Text boxes
        let emergencyName = txtEmergencyName.text ?? ""
        let emergencyPhone = txtEmergencyPhone.text ?? ""

        NotificationLogic.updateEmergencyContact(emergencyName: emergencyName, emergencyPhone: emergencyPhone, completion: {success in
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
     //MARK: isValidPhoneNumber()
     - Description: Updates Emergency Contact Entries.
     -------------------------------------------------------------------*/
    
}
