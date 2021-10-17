//
//  UserDefaults+Extension.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-11.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: extension UserDefaults
 - Description: Holds exteended logic for User Defaults
 -----------------------------------------------------------------------*/
extension UserDefaults {
    
    /*--------------------------------------------------------------------
     //MARK: getSwitchState()
     - Description: Returns boolean of switch state from User Defaults.
     -------------------------------------------------------------------*/
    func getSwitchState(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setSwitchState()
     - Description: Sets switch state in User Defaults.
     -------------------------------------------------------------------*/
    func setSwitchState(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
