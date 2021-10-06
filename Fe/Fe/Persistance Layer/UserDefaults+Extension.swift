//
//  UserDefaults+Extension.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-06.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Ext: UserDefaults
 - Description: Extension methods for using UserDefaults.
 -----------------------------------------------------------------------*/
extension UserDefaults {
    
    /*--------------------------------------------------------------------
     //MARK: setSwitchState()
     - Description: Set state of switch key in User Defaults.
     -------------------------------------------------------------------*/
    func setSwitchState(key: String, value: Bool?) {
        if value != nil {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    /*--------------------------------------------------------------------
     //MARK: getSwitchState()
     - Description: Get state of switch key in User Defaults.
     -------------------------------------------------------------------*/
    func getSwitchState(key: String) -> Bool? {
        return UserDefaults.standard.value(forKey: key) as? Bool
    }
}
