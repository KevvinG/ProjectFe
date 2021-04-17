//
//  SettingsNotificationPermissionsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-13.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: SettingsNotificationPermissionssViewController : UIViewController
 - Description: Holds logic for the Notification Permissions Screen.
 -----------------------------------------------------------------------*/
class SettingsNotificationPermissionsViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var swUnusualSensor: UISwitch!
    @IBOutlet var swMedicationReminder: UISwitch!
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Logic to initialize some code before screen loads.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     - Function: swSensorActivityStateChanged()
     - Description: Logic for changing notifications for unusual
     sensor activity detected Permission.
     -------------------------------------------------------------------*/
    @IBAction func swSensorActivityStateChanged(_ sender: Any) {
        if swUnusualSensor.isOn {
            print("Notifications for Unusual Sensor Activity Switch is on.")
        } else {
            print("Notifications for Unusual Sensor Activity Switch is off.")
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: swMedicationReminderStateChanged()
     - Description: Logic for changing notifications for daily medication
     reminder Permission.
     -------------------------------------------------------------------*/
    @IBAction func swMedicationReminderStateChanged(_ sender: Any) {
        if swUnusualSensor.isOn {
            print("Notifications for Daily Medication Reminder Switch is on.")
        } else {
            print("Notifications for Daily Medication Reminder Switch is off.")
        }
    }
    
}
