//
//  NotificationPermissionsLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation
import UserNotifications

/*------------------------------------------------------------------------
 //MARK: Class NotificationPermissionsLogic
 - Description: Holds logic for the Notification Settings Screen.
 -----------------------------------------------------------------------*/
class NotificationPermissionsLogic {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: getEmergencyContactData()
     - Description: Call Firebase to fetch emegency contact data.
     -------------------------------------------------------------------*/
    func getEmergencyContactData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getEmergencyContactData(completion: { userData in
            completion(userData)
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateEmergencyContact()
     - Description: Call Firebase to update emergency contact data.
     -------------------------------------------------------------------*/
    func updateEmergencyContact(emergencyName: String, emergencyPhone: String, completion: @escaping (_ successful: Bool) -> Void) {
        FirebaseAccessObject().updateEmergencyContactData(emergencyName: emergencyName, emergencyPhone: emergencyPhone, completion: { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: getSwitchStateForUI()
     - Description: Set on screen state of switch.
     -------------------------------------------------------------------*/
    func getSwitchStateForUI(key: String) -> Bool {
        if let switchValue = UserDefaults.standard.getSwitchState(key: key), switchValue {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: getTimeValueForUI()
     - Description: Set on screen time for Time Picker.
     -------------------------------------------------------------------*/
    func getTimeValueForUI(key: String) -> String {
        if let timeValue = UserDefaults.standard.getValue(key: key) {
            return timeValue
        } else {
            return "12"
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateSwitchStateinUserDefaults()
     - Description: Updates current state of switch.
     -------------------------------------------------------------------*/
    func updateSwitchStateinUserDefaults(key: String, value: Bool) {
        UserDefaults.standard.setSwitchState(key: key, value: value)
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateValueStateinUserDefaults()
     - Description: Updates current state of time value.
     -------------------------------------------------------------------*/
    func updateValueStateinUserDefaults(keyHour: String, valueHour: String, keyMinute: String, valueMinute: String) {
        UserDefaults.standard.setValue(key: keyHour, value: valueHour)
        UserDefaults.standard.setValue(key: keyMinute, value: valueMinute)
    }
    
    /*--------------------------------------------------------------------
     //MARK: scheduleMedicationReminder()
     - Description: Set up reminder notification for medication.
     -------------------------------------------------------------------*/
    func scheduleMedicationReminder(hour: String, minute: String) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Here is your friendly reminder to take your medication!"
        content.badge = NSNumber(value: 1)
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour) ?? 8
        dateComponents.minute = Int(minute) ?? 0
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Error adding request to Notification Center: \(String(describing: error))")
           }
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: cancelAllScheduledNotifications()
     - Description: Cancels all Notifications
     -------------------------------------------------------------------*/
    func cancelAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateSwitchInFB()
     - Description: send updated state of switch to Firebase.
     -------------------------------------------------------------------*/
    func updateSwitchInFB(key: String, value: String) {
        FBObj.updateSwitchInFB(key: key, value: value)
    }
}
