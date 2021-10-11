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
    
    /*--------------------------------------------------------------------
     //MARK: setMedicationNotificationSwitchState()
     - Description: Set on screen state of medication notification switch.
     -------------------------------------------------------------------*/
    func setMedicationNotificationSwitchState(key: String) -> Bool {
        if let switchValue = UserDefaults.standard.getSwitchState(key: key), switchValue {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateMedicationNotificationSwitchState()
     - Description: Updates current state of medication notification switch.
     -------------------------------------------------------------------*/
    func updateMedicationNotificationSwitchState(key: String, value: Bool) {
        UserDefaults.standard.setSwitchState(key: key, value: value)
    }
    
    /*--------------------------------------------------------------------
     //MARK: scheduleMedicationReminder()
     - Description: Set up reminder notification for medication.
     -------------------------------------------------------------------*/
    func scheduleMedicationReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Have you taken your medication today?"
        content.badge = NSNumber(value: 1)
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.hour = 8   // 8 AM
        dateComponents.minute = 0 // 0 minutes
           
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
}
