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
    @IBOutlet var btnUpdateEmergencyContact: UIButton!
    @IBOutlet var medicationTimePicker: UIDatePicker!
    
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Logic to initialize some code before screen loads.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEmergencyContactData()
        self.setupTextFields()
        
        swHRNotification.setOn(NotificationLogic.getSwitchStateForUI(key: UserDefaultKeys.swNotificationHRKey.description), animated: false)
        swBONotification.setOn(NotificationLogic.getSwitchStateForUI(key: UserDefaultKeys.swNotificationBOKey.description), animated: false)
        swMedicationReminder.setOn(NotificationLogic.getSwitchStateForUI(key: UserDefaultKeys.swNotificationMedicationReminderKey.description), animated: false)
        setTimePickerValuesInUI()
        swEmergencyContactState.setOn(NotificationLogic.getSwitchStateForUI(key: UserDefaultKeys.swNotifyEmergencyContactKey.description), animated: false)
        modifyUIState() // Set Emergency Contact switch and textfields
        
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
     //MARK: txtEmergencyNameFieldChanged()
     - Description: Ensure name is properly formatted.
     -------------------------------------------------------------------*/
    @IBAction func txtEmergencyNameFieldChanged(_ sender: Any) {
        // If Emergency Contact Switch is on, ensure this field is validated
        if swEmergencyContactState.isOn {
            let name = self.txtEmergencyName.text ?? ""
            let isValid = validation.validateName(name: name)
            if isValid {
                self.txtEmergencyName.backgroundColor = .FeValidationGreen
            } else {
                self.txtEmergencyName.backgroundColor = .FeValidationRed
            }
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: txtEmergencyContactFieldChanged()
     - Description: Ensure phone number is properly formatted.
     -------------------------------------------------------------------*/
    @IBAction func txtEmergencyContactFieldChanged(_ sender: Any) {
        if swEmergencyContactState.isOn {
            let phoneNumber = self.txtEmergencyPhone.text ?? ""
            let isValid = validation.validatePhoneNumber(phoneNumber: phoneNumber)
            if isValid {
                self.txtEmergencyPhone.backgroundColor = .FeValidationGreen
            } else {
                self.txtEmergencyPhone.backgroundColor = .FeValidationRed
            }
        }
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
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationHRKey.description, value: true)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationHRKey.description, value: "true")
        } else {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationHRKey.description, value: false)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationHRKey.description, value: "false")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBOSensorStateChanged()
     - Description: Logic for turning on/off blood oxygen notifications.
     -------------------------------------------------------------------*/
    @IBAction func swBOSensorStateChanged(_ sender: Any) {
        if swBONotification.isOn {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationBOKey.description, value: true)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationBOKey.description, value: "true")
        } else {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationBOKey.description, value: false)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationBOKey.description, value: "false")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swMedicationReminderStateChanged()
     - Description: Logic for changing notifications for daily medication
     reminder Permission.
     -------------------------------------------------------------------*/
    @IBAction func swMedicationReminderStateChanged(_ sender: Any) {
        if swMedicationReminder.isOn {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: true)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: "true")
            let (hour, minute) = getTimePickerValues()
            NotificationLogic.scheduleMedicationReminder(hour: hour, minute: minute)
        } else {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: false)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: "false")
            NotificationLogic.cancelAllScheduledNotifications()
        }
        modifyUIState()
    }
    
    /*--------------------------------------------------------------------
     //MARK: onMedTimePickerChange()
     - Description: update User Defaults for time when changed.
     -------------------------------------------------------------------*/
    @IBAction func onMedTimePickerChange(_ sender: Any) {
        if swMedicationReminder.isOn {
            setTimePickerValuesInUserDefaults()
            NotificationLogic.cancelAllScheduledNotifications()
            let (hour, minute) = getTimePickerValues()
            NotificationLogic.scheduleMedicationReminder(hour: hour, minute: minute)
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: getTimePickerValues() -> (String, String)
     - Description: get and return hour and minute from time picker.
     -------------------------------------------------------------------*/
    func getTimePickerValues() -> (String, String) {
        let date = medicationTimePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = String(components.hour!)
        let minute = String(components.minute!)
        return (hour, minute)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setTimePickerValuesInUserDefaults()
     - Description: get hour and minute from time picker and set in UD.
     -------------------------------------------------------------------*/
    func setTimePickerValuesInUserDefaults() {
        let (hour, minute) = getTimePickerValues()
        let hourKey = UserDefaultKeys.medReminderPickerHourKey.description
        let minuteKey = UserDefaultKeys.medReminderPickerMinuteKey.description
        NotificationLogic.updateValueStateinUserDefaults(keyHour: hourKey, valueHour: hour, keyMinute: minuteKey, valueMinute: minute)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setTimePickerValuesInUI()
     - Description: Get Time from User Defaults and fill in Time Picker.
     -------------------------------------------------------------------*/
    func setTimePickerValuesInUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let hour = NotificationLogic.getTimeValueForUI(key: UserDefaultKeys.medReminderPickerHourKey.description)
        let minute = NotificationLogic.getTimeValueForUI(key: UserDefaultKeys.medReminderPickerMinuteKey.description)
        let date = dateFormatter.date(from: "\(hour):\(minute)")
        medicationTimePicker.date = date!
    }
    
    /*--------------------------------------------------------------------
     //MARK: swEmergencyContactStateChanged()
     - Description: Logic for changing state of emergency contact button.
     -------------------------------------------------------------------*/
    @IBAction func swEmergencyContactStateChanged(_ sender: Any) {
        if swEmergencyContactState.isOn {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: true)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: "true")
        } else {
            NotificationLogic.updateSwitchStateinUserDefaults(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: false)
            NotificationLogic.updateSwitchInFB(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: "false")
        }
        modifyUIState()
    }
    
    /*--------------------------------------------------------------------
     //MARK: modifyUIState()
     - Description: Logic for changing UI state if emergency button tapped.
     -------------------------------------------------------------------*/
    private func modifyUIState() {
        // If Emergency switch is off, button and text fields are disabled
        if swEmergencyContactState.isOn {
            self.btnUpdateEmergencyContact.isEnabled = true
            self.btnUpdateEmergencyContact.backgroundColor = UIColor.FeButtonRed
            self.txtEmergencyName.isEnabled = true
            self.txtEmergencyName.backgroundColor = UIColor.white
            self.txtEmergencyPhone.isEnabled = true
            self.txtEmergencyPhone.backgroundColor = UIColor.white
        } else {
            self.btnUpdateEmergencyContact.isEnabled = false
            self.btnUpdateEmergencyContact.setTitleColor(UIColor.FeDisabledGrey, for: .disabled)
            self.btnUpdateEmergencyContact.backgroundColor = UIColor.FeDisabledRed
            self.txtEmergencyName.isEnabled = false
            self.txtEmergencyName.backgroundColor = UIColor.FeDisabledGrey
            self.txtEmergencyPhone.isEnabled = false
            self.txtEmergencyPhone.backgroundColor = UIColor.FeDisabledGrey
        }
        
        // If Medication Reminder switch is off, disable time picker
        if swMedicationReminder.isOn {
            self.medicationTimePicker.isEnabled = true
            self.medicationTimePicker.backgroundColor = UIColor.white
        } else {
            self.medicationTimePicker.isEnabled = false
            self.medicationTimePicker.backgroundColor = UIColor.FeDisabledGrey
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateEmergencyBtnTapped()
     - Description: Updates Emergency Contact Entries.
     -------------------------------------------------------------------*/
    @IBAction func updateEmergencyBtnTapped(_ sender: Any) {
        // If both boxes are validated, proceed to update
        if validation.validateName(name: txtEmergencyName.text ?? ""), validation.validatePhoneNumber(phoneNumber: txtEmergencyPhone.text ?? "") {
            // Get values from Text boxes
            let emergencyName = txtEmergencyName.text ?? ""
            let emergencyPhone = txtEmergencyPhone.text ?? ""

            NotificationLogic.updateEmergencyContact(emergencyName: emergencyName, emergencyPhone: emergencyPhone, completion: { success in
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
        } else {
            let msg = "Please Verify:\n Name has no numbers.\n Phone number is 10 digits. Example: 12223334444"
            let updateAlert = UIAlertController(title: "Cannot Update", message: msg, preferredStyle: UIAlertController.Style.alert)
            updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(updateAlert, animated: true, completion: nil)
        }
    }
}
