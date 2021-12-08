//
//  SensorDeviceObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-10-14.
//

//MARK: Imports
import Foundation
import CoreBluetooth

/*--------------------------------------------------------------------
 //MARK: SensorDeviceObject: NSObject
 - Description: identifiers for Sensor.
 -------------------------------------------------------------------*/
class SensorDeviceObject: NSObject {

    /// MARK: - Particle LED services and charcteristics Identifiers

//    public static let deviceServiceUUID     = CBUUID.init(string: "d69855f7-eeb5-0294-7545-2ce5408de60f")
    
//    public static let deviceServiceUUID     = CBUUID.init(string: "0000ffe0-0000-1000-8000-00805f9b34fb")
    
    public static let deviceServiceUUID     = CBUUID.init(string: "FFE0")
    
    public static let deviceRXUUID = CBUUID.init(string: "FFE1")
    public static let deviceTXUUID = CBUUID.init(string: "FFE1")

//    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
//    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
//    public static let blueLEDCharacteristicUUID  = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")

}
