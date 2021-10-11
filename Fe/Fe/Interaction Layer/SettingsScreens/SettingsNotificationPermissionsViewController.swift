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
    
    // UI Variables
    @IBOutlet var swHRNotification: UISwitch!
    @IBOutlet var swBONotification: UISwitch!
    @IBOutlet var swMedicationReminder: UISwitch!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Logic to initialize some code before screen loads.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        swMedicationReminder.setOn(NotificationLogic.setMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationMedicationKey.description), animated: false)
    }
    
    /*--------------------------------------------------------------------
     //MARK: swHRSensorStateChanged()
     - Description: Logic for turning on/off heart rate notifications.
     -------------------------------------------------------------------*/
    @IBAction func swHRSensorStateChanged(_ sender: Any) {
        if swHRNotification.isOn {
            print("Notifications for Unusual HR Sensor Activity Switch is on.")
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationHRKey.description, value: true)
        } else {
            print("Notifications for Unusual HR Sensor Activity Switch is off.")
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationHRKey.description, value: false)
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBOSensorStateChanged()
     - Description: Logic for turning on/off blood oxygen notifications.
     -------------------------------------------------------------------*/
    @IBAction func swBOSensorStateChanged(_ sender: Any) {
        if swBONotification.isOn {
            print("Notifications for Unusual Blood Oxygen Sensor Activity Switch is on.")
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationBloodOxygenKey.description, value: true)
        } else {
            print("Notifications for Unusual Blood Oxygen Sensor Activity Switch is off.")
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationBloodOxygenKey.description, value: false)
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
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationMedicationKey.description, value: true)
            NotificationLogic.scheduleMedicationReminder()
        } else {
            print("Med Reminder Off - Removed all tasks")
            NotificationLogic.updateMedicationNotificationSwitchState(key: UserDefaultKeys.switchNotificationMedicationKey.description, value: false)
            NotificationLogic.cancelAllScheduledNotifications()
        }
    }
    
}
