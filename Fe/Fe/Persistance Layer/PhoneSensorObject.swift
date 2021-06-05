//
//  PhoneSensorObject.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-05-07.
//

// Imports
import Foundation
import CoreMotion
import CoreLocation

/*------------------------------------------------------------------------
 - Class: PhoneSensorObject
 - Description: Holds methods for directly accessing the phone sensors.
 -----------------------------------------------------------------------*/
class PhoneSensorObject: NSObject {
    
    // Class Variables
    let altimeter = CMAltimeter()
    
    /*--------------------------------------------------------------------
     - Function: fetchPressure()
     - Description: Fetches latest Pressure reading from Barometer.
     -------------------------------------------------------------------*/
    func fetchPressure(completion: @escaping (_ pressure: String) -> Void) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                let pressure = String.init(format: "%.2f", (data?.pressure.floatValue)!*10)
                completion(pressure)
            }
        } else {
            print("Alt Sensor Not Available.")
            completion("NA")
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchElevation()
     - Description: Fetches latest elevation from phone sensor.
     -------------------------------------------------------------------*/
    func fetchElevation(completion: @escaping (_ pressure: String) -> Void) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                let relAlt = String.init(format: "%.2f", (data?.relativeAltitude.floatValue)!)
                completion(relAlt)
            }
        } else {
            print("Alt Sensor Not Available.")
            completion("NA")
        }
    }
}
