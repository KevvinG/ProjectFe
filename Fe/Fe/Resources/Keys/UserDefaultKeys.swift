//
//  UserDefaultKeys.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-06.
//

//MARK: Imports
import Foundation

//MARK: Enum UserDefaultKeys
enum UserDefaultKeys: String {
    
    //MARK: Login Screen
    case switchNotificationMedicationKey
    
    //MARK: Descriptions
    var description : String {
        switch self {
        case .switchNotificationMedicationKey:
            return "Switch_Notification_Medication_State"
        }
    }
}
