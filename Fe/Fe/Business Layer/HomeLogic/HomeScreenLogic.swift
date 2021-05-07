//
//  HomeScreenLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

// Imports
import Foundation

/*------------------------------------------------------------------------
 - Class: HomeScreenLogic
 - Description: Holds logic for the Home Screen
 -----------------------------------------------------------------------*/
class HomeScreenLogic {
    
    // Class Variables
    let HKObj = HKAccessObject()
    let FBObj = FirebaseAccessObject()
    let CDObj = CoreDataAccessObject()
    let phoneObj = PhoneSensorObject()
    
    /*--------------------------------------------------------------------
     - Function: getLatestHR()
     - Description: Fetches latest HR Reading.
     -------------------------------------------------------------------*/
    func getLatestHR() -> String {
        return String(CDObj.fetchLatestHR())
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchPressureReading()
     - Description: Obtains pressure reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchPressureReading(completion: @escaping (_ pressure: String) -> Void) {
        phoneObj.fetchPressure(completion: { (pressure) -> Void in
            completion(pressure)
        })
    }
    
}
