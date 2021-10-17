//
//  UserDefaultKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-11.
//

import Foundation

//MARK: Enum UserDefaultKeys
enum UserDefaultKeys: String {
    
    case swGPSSensorKey
    case swAltimeterSensorKey
    case swHeartRateSensorKey
    case swBloodOxygeenSensorKey
    case swContact911EmergencyKey
    case swNotifyEmergencyContactKey
    case swNotificationHRKey
    case swNotificationBOKey
    case swNotificationMedicationReminderKey
    
    var description: String {
        switch self {
        case .swGPSSensorKey:
            return "Switch_Permission_Sensor_GPS_State"
        case .swAltimeterSensorKey:
            return "Switch_Permission_Sensor_Altimeter_State"
        case .swHeartRateSensorKey:
            return "Switch_Permission_Sensor_Heart_Rate_State"
        case .swBloodOxygeenSensorKey:
            return "Switch_Permission_Sensor_Blood_Oxygen_State"
        case .swContact911EmergencyKey:
            return "Switch_Permission_Contact_911_Emergency_State"
        case .swNotifyEmergencyContactKey:
            return "Switch_Permission_Contact_Emergency_State"
        case .swNotificationHRKey:
            return "Switch_Notification_Heart_Rate_State"
        case .swNotificationBOKey:
            return "Switch_Notification_Blood_Oxygen_State"
        case .swNotificationMedicationReminderKey:
            return "Switch_Notification_Medication_Reminnder_State"
        }
    }
}
