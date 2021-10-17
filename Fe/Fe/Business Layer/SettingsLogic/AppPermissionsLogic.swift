//
//  AppPermissionsLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Class AppPermissionsLogic
 - Description: Holds logic for the App Permissions Settings Screen.
 -----------------------------------------------------------------------*/
class AppPermissionsLogic {
    
    /*--------------------------------------------------------------------
     //MARK: setSwitchState()
     - Description: Set on screen state of switch.
     -------------------------------------------------------------------*/
    func setSwitchState(key: String) -> Bool {
        if let switchValue = UserDefaults.standard.getSwitchState(key: key), switchValue {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateSwitchState()
     - Description: Updates current state of switch.
     -------------------------------------------------------------------*/
    func updateSwitchState(key: String, value: Bool) {
        UserDefaults.standard.setSwitchState(key: key, value: value)
    }
}
