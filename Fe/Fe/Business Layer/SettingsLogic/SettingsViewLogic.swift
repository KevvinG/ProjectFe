//
//  SettingsViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Class SettingsViewLogic
 - Description: Holds logic for the Settings Screen.
 -----------------------------------------------------------------------*/
class SettingsViewLogic {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: deleteFBSensorData()
     - Description: Call Firebase to delete Sensor Data.
     -------------------------------------------------------------------*/
    func deleteFBSensorData() {
        FBObj.deleteSensorData()
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteFBData()
     - Description: Call Firebase to delete Data.
     -------------------------------------------------------------------*/
    func deleteFBData() {
        FBObj.deleteData()
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAccount()
     - Description: Call Firebase to delete account.
     -------------------------------------------------------------------*/
    func deleteAccount() {
        FBObj.deleteAccount()
    }
    
    /*--------------------------------------------------------------------
     //MARK: logOut()
     - Description: Call Firebase to log out.
     -------------------------------------------------------------------*/
    func logOut() {
        FBObj.signOut()
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateEmergencyContact()
     - Description: Call Firebase to update emergency contact data.
     -------------------------------------------------------------------*/
    func updateEmergencyContact(doctorPhone : String, emergencyName : String, emergencyPhone : String, completion: @escaping (_ successful: Bool) -> Void) {
        
        FirebaseAccessObject().updateEmergencyContactData(doctorPhone: doctorPhone, emergencyName: emergencyName, emergencyPhone: emergencyPhone, completion: { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: getEmergencyContactData()
     - Description: Call Firebase to fetch emegency contact data.
     -------------------------------------------------------------------*/
    func getEmergencyContactData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getEmergencyContactData(completion: { userData in
            completion(userData)
        })
    }
    
}
