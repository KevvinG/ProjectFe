//
//  UserDefaultKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-11.
//

import Foundation

//MARK: Enum UserDefaultKeys
enum UserDefaultKeys: String {
    
    case swNotificationHRKey
    case swNotificationBOKey
    case swNotificationMedicationReminderKey
    
    var description: String {
        switch self {
        case .swNotificationHRKey:
            return "Switch_Notification_Heart_Rate_State"
        case .swNotificationBOKey:
            return "Switch_Notification_Blood_Oxygen_State"
        case .swNotificationMedicationReminderKey:
            return "Switch_Notification_Medication_Reminnder_State"
        }
    }
}
