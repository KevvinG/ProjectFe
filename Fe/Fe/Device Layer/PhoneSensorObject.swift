//
//  PhoneSensorObject.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-05-07.
//

//MARK: Imports
import Foundation
import CoreMotion
import CoreLocation

/*------------------------------------------------------------------------
 //MARK: PhoneSensorObject
 - Description: Holds methods for directly accessing the phone sensors.
 -----------------------------------------------------------------------*/
class PhoneSensorObject: NSObject {
    
    // Class Variables
    let altimeter = CMAltimeter()
    let CDObj = CoreDataAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: startAltitudeUpdates()
     - Description: Starts Altitude Updates.
     - We have no control over the frequency of updates. Always 1 second.
     -------------------------------------------------------------------*/
    func startAltitudeUpdates() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                let pressure = String.init(format: "%.2f", (data?.pressure.floatValue)!*10)
                self.CDObj.createAirPressureDataTableEntry(apValue: Float(pressure)!)
            }
        } else {
            print("Alt Sensor Not Available.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: stopAltitudeUpdates()
     - Description: Stops Altitude Updates
     -------------------------------------------------------------------*/
    func stopAltitudeUpdates() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.stopRelativeAltitudeUpdates()
        } else {
            print("Alt Sensor Not Available.")
        }
    }
}
