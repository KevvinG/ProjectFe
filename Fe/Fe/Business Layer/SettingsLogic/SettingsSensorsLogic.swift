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
class SettingsSensorsLogic {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: setSwitchStateInUI()
     - Description: Set on screen state of switch.
     -------------------------------------------------------------------*/
    func setSwitchStateInUI(key: String) -> Bool {
        if let switchValue = UserDefaults.standard.getSwitchState(key: key), switchValue {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateSwitchInUserDefaults()
     - Description: Updates current state of switch.
     -------------------------------------------------------------------*/
    func updateSwitchInUserDefaults(key: String, value: Bool) {
        UserDefaults.standard.setSwitchState(key: key, value: value)
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateSwitchInFB()
     - Description: send updated state of switch to Firebase.
     -------------------------------------------------------------------*/
    func updateSwitchInFB(key: String, value: String) {
        FBObj.updateSwitchInFB(key: key, value: value)
    }
}
