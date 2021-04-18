//
//  SettingsViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

import Foundation

class SettingsViewLogic {
    let FBObj = FirebaseAccessObject()
    
    func deleteFBSensorData() {
        FBObj.deleteSensorData()
    }
    
    func deleteFBData() {
        FBObj.deleteData()
    }
    
    func deleteAccount() {
        FBObj.deleteAccount()
    }
    
    func logOut() {
        FBObj.signOut()
    }
    
    func updateEmergencyContact(doctorPhone : String, emergencyName : String, emergencyPhone : String, completion: @escaping (_ successful: Bool) -> Void) {
        
        FirebaseAccessObject().updateEmergencyContactData(doctorPhone: doctorPhone, emergencyName: emergencyName, emergencyPhone: emergencyPhone, completion: { success in
            var msg = ""
            if success {
                msg = "Successfully updated emergency contact details"
                completion(true)
            } else {
                msg = "Update Not Successful"
                completion(false)
            }
        })
    }
    
    func getEmergencyContactData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getEmergencyContactData(completion: { userData in
            completion(userData)
        })
    }
    
}
