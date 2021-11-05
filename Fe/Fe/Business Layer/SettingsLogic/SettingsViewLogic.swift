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
    let CDObj = CoreDataAccessObject()
    let PhoneObj = PhoneSensorObject()
    
    /*--------------------------------------------------------------------
     //MARK: deleteFBSensorData()
     - Description: Call Core Data to delete Sensor Data.
     -------------------------------------------------------------------*/
    func deleteSensorData() -> Bool {
        let hrDeleted = CDObj.deleteAllHREntries()
        let bloodOxygenDeleted = CDObj.deleteAllBloodOxygenEntries()
        let elevationDeleted = CDObj.deleteAllElevationEntries()
        let airPressureDeleted = CDObj.deleteAllairPressureEntries()
        
        if hrDeleted, bloodOxygenDeleted, elevationDeleted, airPressureDeleted {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAccount()
     - Description: Call Firebase to delete account.
     -------------------------------------------------------------------*/
    func deleteAccount(completion: @escaping (_ success: Bool) -> Void) {
        FBObj.deleteAccount(completion: { success in
            completion(success)
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: logOut()
     - Description: Call Firebase to log out.
     -------------------------------------------------------------------*/
    func logOut() {
        PhoneObj.stopAltitudeUpdates()
        
        FBObj.signOut()
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateDoctorContact()
     - Description: Call Firebase to update doctor contact data.
     -------------------------------------------------------------------*/
    func updateDoctorContact(doctorPhone : String, completion: @escaping (_ successful: Bool) -> Void) {
        FBObj.updateDoctorContactData(doctorPhone: doctorPhone, completion: { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: getDoctorContactData()
     - Description: Call Firebase to fetch doctor contact data.
     -------------------------------------------------------------------*/
    func getDoctorContactData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getDoctorContactData(completion: { userData in
            completion(userData)
        })
    }
}
