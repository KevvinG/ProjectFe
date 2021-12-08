//
//  CBUUIDS.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-10-14.
//

//MARK: Imports
import Foundation
import CoreBluetooth

/*------------------------------------------------------------------------
 //MARK: struct CBUUIDs
 - Description: struct for bluetooth device IDs.
 -----------------------------------------------------------------------*/
//MARK: CBUUIDs
public struct CBUUIDs{

    static let kBLEService_UUID = "FFE0"
//    static let kBLEService_UUID = "d69855f7-eeb5-0294-7545-2ce5408de60f"
    static let kBLE_Characteristic_uuid_Tx = "FFE1"
    static let kBLE_Characteristic_uuid_Rx = "FFE1"
    static let MaxCharacters = 20

    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)

}
