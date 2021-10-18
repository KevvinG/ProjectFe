//
//  HomeVC.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-13.
//

//MARK: Imports
import UIKit
import CoreData
import CoreBluetooth

/*------------------------------------------------------------------------
 //MARK: HomeVC : UIViewController
 - Description: Holds UI Interactions for the Home Screen
 -----------------------------------------------------------------------*/
class HomeVC: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate  {
    
    // Class Variables
    let HSLogic = HomeScreenLogic()
    let FBObj = FirebaseAccessObject()
    let HRObj = HeartRateLogic()
    let BldOxObj = BloodOxygenLogic()
    let AltObj = AltitudeLogic()
    let DALogic = DataAnalysisLogic()
    let CDObj = CoreDataAccessObject()
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic!
    var rxCharacteristic: CBCharacteristic!
    let DAObj = DataAnalysisLogic()
    
    // UI Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblHeartRateValue: UILabel!
    @IBOutlet var lblBloodOxygenValue: UILabel!
    @IBOutlet var lblAltitudeValue: UILabel!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)

//        HSLogic.homeScreenSetup() // Setup options once logged in.
        
        // Check if user already exists and add new user if not.
        FBObj.checkIfNewUser()
        
        // Set Name at top of UI
        FBObj.getUserName(completion: { name in
            self.setWelcomeTitle(title: "Welcome back, \(name)!")
        })
        
        // Set off each method at start to fill UI
        altTimerFire()
        hrTimerfire()
        bloodOxTimerfire()
        
        // Timer
        let timer = CustomTimer { (seconds) in
            
            if seconds % 300 == 0 { // Fire every 5 minutes (300 seconds)
                if let hrSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationHRKey.description), hrSwitchState {
                    self.DAObj.analyzeHeartRateData()
                }
                
                if let bloodOxSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationBOKey.description), bloodOxSwitchState {
                    self.DAObj.analyzeBloodOxygenData()
                }
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
        self.setHRButtonValue(labelValue: "\(hrVal) BPM")
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
        self.setBloodOxButtonValue(labelValue: "\(bloodOxygen) %")
        print("Blood Ox Timer Val: \(bloodOxygen)")
        // let bloodOxVal = BldOxObj = fetchLatestBloodOxReading()
//        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxygen in
//            self.setBloodOxButtonValue(labelValue: "\(bloodOxygen) %")
//            print("Blood Ox Timer Val: \(bloodOxygen)")
        }
    
    /*--------------------------------------------------------------------
     //MARK: AltTimerFire()
     - Description: Method to update Air Pressure.
     -------------------------------------------------------------------*/
    @objc func altTimerFire()
    {
        AltObj.fetchPressureReading(completion: { pressure in
            self.setAltitudeButtonValue(labelValue: "\(pressure) hPa")
            print("Air Pressure Timer Val: \(pressure)")
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: setWelcomeTitle()
     - Description: Set UI Welcome Title
     -------------------------------------------------------------------*/
    func setWelcomeTitle(title: String) {
        self.lblTitle.text = title
    }
    
    /*--------------------------------------------------------------------
     //MARK: setHRButtonValue()
     - Description: Set HR Button Value
     -------------------------------------------------------------------*/
    func setHRButtonValue(labelValue: String) {
        self.lblHeartRateValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: setBloodOxButtonValue()
     - Description: Set Blood Oxygen Button Value
     -------------------------------------------------------------------*/
    func setBloodOxButtonValue(labelValue: String) {
        self.lblBloodOxygenValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: setAltitudeButtonValue()
     - Description: Set Altitude Button Value
     -------------------------------------------------------------------*/
    func setAltitudeButtonValue(labelValue: String) {
        self.lblAltitudeValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func btnHeartRateTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToHeartRateScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnBloodOxygenTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func btnBloodOxygenTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToBloodOxygenScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnAltitudeTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func btnAltitudeTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToAltitudeScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func btnSymptomsTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnMoreInfoTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func btnMoreInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
