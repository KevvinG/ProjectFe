//
//  SensorDevicePackage.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-10-15.
//

//MARK: Imports
import Foundation
import CoreBluetooth

/*--------------------------------------------------------------------
 //MARK: SensorDevicePackage: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate
 - Description: class for connecting sensor device to mobile phone.
 -------------------------------------------------------------------*/
class SensorDevicePackage: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    let CDObj = CoreDataAccessObject()
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic!
    var rxCharacteristic: CBCharacteristic!
    
    /*--------------------------------------------------------------------
     //MARK: init()
     - Description: initializer
     -------------------------------------------------------------------*/
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /*--------------------------------------------------------------------
     //MARK: centralManagerDidUpdateState()
     - Description: If we're powered on, start scanning
     -------------------------------------------------------------------*/
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", SensorDeviceObject.deviceServiceUUID);
//                centralManager.scanForPeripherals(withServices: [SensorDeviceObject.deviceServiceUUID],
//                                                  options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            centralManager.scanForPeripherals(withServices: nil)
        }
    }

    /*--------------------------------------------------------------------
     //MARK: centralManager()
     - Description: Handles the result of the scan.
     - Did Discover new device
     -------------------------------------------------------------------*/
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//            self.centralManager.stopScan()
        // Copy the peripheral instance
        self.peripheral = peripheral
        if self.peripheral.name == "BT05" {
            //Stop scan when it finds our device
            self.centralManager.stopScan()
        }
        self.peripheral.delegate = self
        // Connect
        self.centralManager.connect(self.peripheral, options: nil)
    }

    /*--------------------------------------------------------------------
     //MARK: centralManager()
     - Description: The handler if we do connect succesfully
     -------------------------------------------------------------------*/
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Sensor Device connected")
            peripheral.discoverServices([SensorDeviceObject.deviceServiceUUID])
        }
    }

    /*--------------------------------------------------------------------
     //MARK: peripheral()
     - Description: Handles discovery event
     -------------------------------------------------------------------*/
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == SensorDeviceObject.deviceServiceUUID {
                    print("Sensor service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
                }
            }
        }
    }

    /*--------------------------------------------------------------------
     //MARK: peripheral()
     - Description: Handling discovery of characteristics
     -------------------------------------------------------------------*/
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == SensorDeviceObject.deviceTXUUID {
                    txCharacteristic = characteristic
                    print("Device TX Characteristic Found")
                }
                if characteristic.uuid == SensorDeviceObject.deviceRXUUID {
                    rxCharacteristic = characteristic
                    print("Device RX Characteristic Found")
                    peripheral.setNotifyValue(true, for: rxCharacteristic)
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }

    /*--------------------------------------------------------------------
     //MARK: peripheral()
     - Description: Handle data receipt
     -------------------------------------------------------------------*/
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var characteristicASCIIValue = NSString()
        guard characteristic == txCharacteristic,

              let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

          characteristicASCIIValue = ASCIIstring

//        print("Value Recieved: \((characteristicASCIIValue as String))")

        let input = characteristicASCIIValue as String

        let splitInput = input.split(separator: ",")
        print(splitInput)
        if splitInput.count == 2 {
            if let number = Int(splitInput[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                print("HR value \(number)")
                    CDObj.createHeartRateTableEntry(hrValue: String(number))
            }
            if let number2 = Int(splitInput[1].components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                print("Blood ox value \(number2)")
                CDObj.createBloodOxygenTableEntry(bloodOxValue: number2)
            }
        }
    }
}
