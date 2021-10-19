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
    func deleteSensorData() {
        //TODO: DELETE SENSOR DATA FROM CORE DATA
        FBObj.deleteSensorData()
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteFBData()
     - Description: Call Firebase to delete Data.
     -------------------------------------------------------------------*/
    func deleteData() {
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
     //MARK: updateDoctorContact()
     - Description: Call Firebase to update doctor contact data.
     -------------------------------------------------------------------*/
    func updateDoctorContact(doctorPhone : String, completion: @escaping (_ successful: Bool) -> Void) {
        FirebaseAccessObject().updateDoctorContactData(doctorPhone: doctorPhone, completion: { success in
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
