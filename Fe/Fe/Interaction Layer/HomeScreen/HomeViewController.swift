//
//  HomeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

//MARK: Imports
import UIKit
import CoreData
import CoreBluetooth

/*------------------------------------------------------------------------
 //MARK: HomeViewController : UIViewController
 - Description: Holds logic for the the User Home Screen
 -----------------------------------------------------------------------*/
class HomeViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    let HRObj = HeartRateLogic()
    let BldOxObj = BloodOxygenLogic()
    let AltObj = AltitudeLogic()
    let HSLogic = HomeScreenLogic()
    let DALogic = DataAnalysisLogic()
    let CDObj = CoreDataAccessObject()
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic!
    var rxCharacteristic: CBCharacteristic!
    // UI Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnHeartRate: UIButton!
    @IBOutlet var lblHeartRateValue: UILabel!
    @IBOutlet var btnBloodOx: UIButton!
    @IBOutlet var lblBloodOx: UILabel!
    @IBOutlet var btnAltitude: UIButton!
    @IBOutlet var lblAltitude: UILabel!
    @IBOutlet var btnCheckSymptoms: UIButton!
    @IBOutlet var btnMoreInfo: UIButton!
    

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)

        // Set Name at top of UI
        FBObj.getUserName(completion: { name in
            self.lblTitle.text = "Welcome back, \(name)!"
        })
        
        FBObj.checkIfNewUser() // Check if user already exists and add new user if not.
        
        // Set off each method at start to fill UI
        altTimerFire()
        hrTimerfire()
        bloodOxTimerfire()
        
        // Timer
        let timer = CustomTimer { (seconds) in
            
            if seconds % 300 == 0 { // Fire every 5 minutes (300 seconds)
                self.DALogic.analyzeHeartRateData()
                self.DALogic.analyzeBloodOxygenData()
            }
            
            if seconds % 60 == 0 { // Fire every 60 seconds
                self.altTimerFire()
            }
            
            if seconds % 5 == 0 { // Fire every 5 seconds - Watch sends messages in this interval
                self.hrTimerfire()
                self.bloodOxTimerfire()
            }
        }
        timer.start()
    }
    
    //MARK: Bluetooth logic here
    
    // If we're powered on, start scanning
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
    
    // Handles the result of the scan
    // Did Discover new device
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

//            self.centralManager.stopScan()

            // Copy the peripheral instance
            self.peripheral = peripheral
            if self.peripheral.name == "BT05" {
                //Stop scan when it finds our device
                self.centralManager.stopScan()
            }
            self.peripheral.delegate = self

            // Connect!
            self.centralManager.connect(self.peripheral, options: nil)

        }
    
    // The handler if we do connect succesfully
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            if peripheral == self.peripheral {
                print("Sensor Device connected")
                peripheral.discoverServices([SensorDeviceObject.deviceServiceUUID])
            }
        }
    
    // Handles discovery event
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


    // Handling discovery of characteristics
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
    
    //Handle data receipt
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        var characteristicASCIIValue = NSString()

        guard characteristic == txCharacteristic,

              let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

          characteristicASCIIValue = ASCIIstring

        print("Value Recieved: \((characteristicASCIIValue as String))")
        
        var input = characteristicASCIIValue as String
        
        let splitInput = input.split(separator: ",")
        print(splitInput)
        if splitInput.count == 2 {
            if let number = Int(splitInput[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print("HR value \(number)")
                    CDObj.createHeartRateTableEntry(hrValue: String(number))
            }
            if let number2 = Int(splitInput[1].components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print("Blood ox value \(number2)")
                CDObj.createBloodOxygenTableEntry(bloodOxValue: number2)
            }
        }
        
    }

    /*--------------------------------------------------------------------
     //MARK: HRTimerfire()
     - Description: Method to update Heart Rate.
     -------------------------------------------------------------------*/
    @objc func hrTimerfire()
    {
        let hrVal = HRObj.fetchLatestHrReading()
        self.lblHeartRateValue.text = "\(hrVal) BPM"
        print("HR Timer Val: \(hrVal)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: BloodOxTimerfire()
     - Description: Method to update Blood Oxygen.
     -------------------------------------------------------------------*/
    @objc func bloodOxTimerfire()
    {
//        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxygen in
//            self.lblBloodOx.text = "\(bloodOxygen) %"
//            print("Blood Ox Timer Val: \(bloodOxygen)")
//        })
        let bloodOxygen = BldOxObj.fetchLatestBloodOxReading()
        self.lblBloodOx.text = "\(bloodOxygen) %"
        print("Blood Ox Timer Val: \(bloodOxygen)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: AltTimerFire()
     - Description:  method to update Air Pressure.
     -------------------------------------------------------------------*/
    @objc func altTimerFire()
    {
        AltObj.fetchPressureReading(completion: { pressure in
            self.lblAltitude.text = "\(pressure) hPa"
            print("Air Pressure Timer Val: \(pressure)")
        })
    }

    /*--------------------------------------------------------------------
     //MARK: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func heartRateBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToHeartRateScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: bloodOxygenBtnTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func bloodOxygenBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToBloodOxygenScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: altitudeBtnTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func altitudeBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAltitudeScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: viewDocumentsBtnTapped()
     - Description: Segue to viewDocuments table View
     -------------------------------------------------------------------*/
    @IBAction func viewDocumentsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToDocumentsScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: uploadDocumentBtnTapped()
     - Description: Segue to upload document view
     -------------------------------------------------------------------*/
    @IBAction func uploadDocumentBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToUploadDocumentScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func checkSymptomsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: moreInformationBtnTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func moreInformationBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
