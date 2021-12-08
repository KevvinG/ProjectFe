//
//  UserDefaultKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-11.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: enum UserDefaultKeys
 - Description: Holds keys for local persistence.
 -----------------------------------------------------------------------*/
//MARK: Enum UserDefaultKeys
public enum UserDefaultKeys: String {
    
    // Threshold values
    case hrThresholdLowKey
    case hrThresholdHighKey
    case bldOxThresholdLowKey
    case bldOxThresholdHighKey
    
    // Switch Keys
    case swAltimeterSensorKey
    case swHeartRateSensorKey
    case swBloodOxygenSensorKey
    case swNotifyEmergencyContactKey
    case swNotificationHRKey
    case swNotificationBOKey
    case swNotificationMedicationReminderKey
    
    // Time Picker Keys
    case medReminderPickerHourKey
    case medReminderPickerMinuteKey
    
    var description: String {
        switch self {
        case .hrThresholdLowKey:
            return "Threshold_HR_Low"
        case .hrThresholdHighKey:
            return "Threshold_HR_High"
        case .bldOxThresholdLowKey:
            return "Threshold_Blood_Oxygen_Low"
        case .bldOxThresholdHighKey:
            return "Threshold_Blood_Oxygen_High"
        case .swAltimeterSensorKey:
            return "Switch_Permission_Sensor_Altimeter_State"
        case .swHeartRateSensorKey:
            return "Switch_Permission_Sensor_Heart_Rate_State"
        case .swBloodOxygenSensorKey:
            return "Switch_Permission_Sensor_Blood_Oxygen_State"
        case .swNotifyEmergencyContactKey:
            return "Switch_Permission_Contact_Emergency_State"
        case .swNotificationHRKey:
            return "Switch_Notification_Heart_Rate_State"
        case .swNotificationBOKey:
            return "Switch_Notification_Blood_Oxygen_State"
        case .swNotificationMedicationReminderKey:
            return "Switch_Notification_Medication_Reminder_State"
        case .medReminderPickerHourKey:
            return "Picker_Notification_Medication_Hour"
        case .medReminderPickerMinuteKey:
            return "Picker_Notification_Medication_Minute"
        }
    }
}
