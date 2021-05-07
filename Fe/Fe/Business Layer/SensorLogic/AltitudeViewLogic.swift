//
//  AltitudeViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

// Imports
import Foundation
import CoreMotion

/*------------------------------------------------------------------------
 - Class: AltitudeViewLogic
 - Description: Holds logic for the Altitude
 -----------------------------------------------------------------------*/
class AltitudeViewLogic {
    
    // Class Variables
    let phoneObj = PhoneSensorObject()
    
    /*--------------------------------------------------------------------
     - Function: fetchPressureReading()
     - Description: Obtains pressure reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchPressureReading(completion: @escaping (_ pressure: String) -> Void) {
        phoneObj.fetchPressure(completion: { (pressure) -> Void in
            completion(pressure)
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchElevationReading()
     - Description: Obtains clevation reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchElevationReading() {
        
    }
}
