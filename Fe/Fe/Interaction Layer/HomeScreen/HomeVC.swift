//
//  HomeVC.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-13.
//

//MARK: Imports
import UIKit
import CoreLocation
import CoreMotion
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
    let DAObj = DataAnalysisLogic()
    let CDObj = CoreDataAccessObject()
    let PhoneObj = PhoneSensorObject()
    let locationManager = CLLocationManager()
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic!
    var rxCharacteristic: CBCharacteristic!
    
    // UI Variables
    @IBOutlet var btnHR: UIButton!
    @IBOutlet var btnBldOx: UIButton!
    @IBOutlet var btnAlt: UIButton!
    @IBOutlet var btnSymptoms: UIButton!
    @IBOutlet var btnChatbot: UIButton!
    @IBOutlet var btnSocialAndGamification: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblHeartRateValue: UILabel!
    @IBOutlet var lblBloodOxygenValue: UILabel!
    @IBOutlet var lblAltitudeValue: UILabel!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        obtainLocationAuth()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Check if user already exists and set switches.  Add new user if not.
        HSLogic.checkIfNewUser(completion: { isNewUser in
            if isNewUser {
                UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdLowKey.description, value: "40")
                UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdHighKey.description, value: "100")
                UserDefaults.standard.setValue(key: UserDefaultKeys.bldOxThresholdLowKey.description, value: "90")
                UserDefaults.standard.setValue(key: UserDefaultKeys.bldOxThresholdHighKey.description, value: "110")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swHeartRateSensorKey.description, value: "true")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: "true")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swAltimeterSensorKey.description, value: "true")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationHRKey.description, value: "true")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationBOKey.description, value: "true")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: "false")
                UserDefaults.standard.setValue(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: "false")
            } else {
                self.HSLogic.getUserDefaults(completion: { dataDict in
                    
                    UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdLowKey.description, value: dataDict["hrLowThreshold"] ?? "40")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdHighKey.description, value: dataDict["hrHighThreshold"] ?? "100")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.bldOxThresholdLowKey.description, value: dataDict["bldOxLowThreshold"] ?? "90")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.bldOxThresholdHighKey.description, value: dataDict["bldOxHighThreshold"] ?? "110")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swHeartRateSensorKey.description, value: dataDict[UserDefaultKeys.swHeartRateSensorKey.description] ?? "true")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: dataDict[UserDefaultKeys.swBloodOxygenSensorKey.description] ?? "true")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swAltimeterSensorKey.description, value: dataDict[UserDefaultKeys.swAltimeterSensorKey.description] ?? "true")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationHRKey.description, value: dataDict[UserDefaultKeys.swNotificationHRKey.description] ?? "true")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationBOKey.description, value: dataDict[UserDefaultKeys.swNotificationBOKey.description] ?? "true")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swNotificationMedicationReminderKey.description, value: dataDict[UserDefaultKeys.swNotificationMedicationReminderKey.description] ?? "false")
                    UserDefaults.standard.setValue(key: UserDefaultKeys.swNotifyEmergencyContactKey.description, value: dataDict[UserDefaultKeys.swNotifyEmergencyContactKey.description] ?? "false")
                })
            }
        })
        
        // Set Name at top of UI
        FBObj.getUserName(completion: { name in
            self.setWelcomeTitle(title: "Welcome Back,\n\(name)!")
        })
        
        // If Permission Granted, fire each sensor too fill UI
        if let altimeterSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swAltimeterSensorKey.description), altimeterSensorSwitchState {
            self.altTimerFire()
        }
        
        if let hrSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swHeartRateSensorKey.description), hrSensorSwitchState {
            self.hrTimerfire()
        }
        
        if let bldOxSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swBloodOxygenSensorKey.description), bldOxSensorSwitchState {
            self.bloodOxTimerfire()
        }
        
        // Timer
        let timer = CustomTimer { (seconds) in
            
            if seconds % 300 == 0 { // Fire every 5 minutes (300 seconds)
                if let hrNotificationSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationHRKey.description), hrNotificationSwitchState {
                    self.DAObj.analyzeHeartRateData()
                }
                
                if let bloodOxNotificationSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationBOKey.description), bloodOxNotificationSwitchState {
                    self.DAObj.analyzeBloodOxygenData()
                }
            }
            
            if seconds % 60 == 0 { // Fire every 60 seconds
                if let altimeterSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swAltimeterSensorKey.description), altimeterSensorSwitchState {
                    self.altTimerFire()
                }
            }
            
            if seconds % 5 == 0 { // Fire every 5 seconds
                if let hrSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swHeartRateSensorKey.description), hrSensorSwitchState {
                    self.hrTimerfire()
                }
                
                if let bldOxSensorSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swBloodOxygenSensorKey.description), bldOxSensorSwitchState {
                    self.bloodOxTimerfire()
                }
            }
        }
        timer.start()
        
        setupButtonUI()
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupButtonUI()
     - Description: creeate pretty buttons
     -------------------------------------------------------------------*/
    func setupButtonUI() {
        // Heart Rate Button
        btnHR.layer.shadowColor = UIColor.black.cgColor
        btnHR.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnHR.layer.shadowRadius = 5
        btnHR.layer.shadowOpacity = 1.0
        let hrImage = UIImage(named: "heart.png")!.alpha(0.3)
        btnHR.setImage(hrImage, for: .normal)
        btnHR.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        
        // Blood Oxygen Button
        btnBldOx.layer.shadowColor = UIColor.black.cgColor
        btnBldOx.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnBldOx.layer.shadowRadius = 5
        btnBldOx.layer.shadowOpacity = 1.0
        let bldOxImage = UIImage(named: "red-blood-cells-1.png")!.alpha(0.3)
        btnBldOx.setImage(bldOxImage, for: .normal)
        btnBldOx.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        
        // Altitude Button
        btnAlt.layer.shadowColor = UIColor.black.cgColor
        btnAlt.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnAlt.layer.shadowRadius = 5
        btnAlt.layer.shadowOpacity = 1.0
        let altImage = UIImage(named: "mountain.png")!.alpha(0.3)
        btnAlt.setImage(altImage, for: .normal)
        btnAlt.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        
        // Symptoms Button
        btnSymptoms.layer.shadowColor = UIColor.black.cgColor
        btnSymptoms.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnSymptoms.layer.shadowRadius = 5
        btnSymptoms.layer.shadowOpacity = 1.0
        let sympImage = UIImage(named: "checklist.png")!.alpha(0.6)
        btnSymptoms.setImage(sympImage, for: .normal)
        btnSymptoms.imageEdgeInsets = UIEdgeInsets(top: 35, left: 40, bottom: 35, right: 30)
        
        // Chatbot Button
        btnChatbot.layer.shadowColor = UIColor.black.cgColor
        btnChatbot.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnChatbot.layer.shadowRadius = 5
        btnChatbot.layer.shadowOpacity = 1.0
        let chatbotImage = UIImage(named: "chatbot.png")!.alpha(0.7)
        btnChatbot.setImage(chatbotImage, for: .normal)
        btnChatbot.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        
        // Social and Gamification Button
        btnSocialAndGamification.layer.shadowColor = UIColor.black.cgColor
        btnSocialAndGamification.layer.shadowOffset = CGSize(width: 5, height: 5)
        btnSocialAndGamification.layer.shadowRadius = 5
        btnSocialAndGamification.layer.shadowOpacity = 1.0
        let socialImage = UIImage(named: "girlaward.png")!.alpha(0.6)
        btnSocialAndGamification.setImage(socialImage, for: .normal)
        btnSocialAndGamification.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
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

        print("Value Recieved: \((characteristicASCIIValue as String))")
        
        let input = characteristicASCIIValue as String
        
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
     //MARK: altTimerFire()
     - Description: Method to update Air Pressure and Elevation.
     -------------------------------------------------------------------*/
    @objc func altTimerFire() {
        PhoneObj.startAltitudeUpdates()
        let airPressure = AltObj.fetchLatestPressureReading()
        
        // Verify theree is a recent reading.
        if airPressure == -1 {
            self.setAltitudeButtonValue(labelValue: "-")
            return
        } else {
            self.setAltitudeButtonValue(labelValue: "\(airPressure)")
        }
        print("Air Pressure Timer Val: \(airPressure) hPa")
        
        let elevation = AltObj.fetchLatestElevationReading()
        print("Elevation Timer Val: \(elevation) meters")
        PhoneObj.stopAltitudeUpdates()
    }
    
    /*--------------------------------------------------------------------
     //MARK: HRTimerfire()
     - Description: Method to update Heart Rate.
     -------------------------------------------------------------------*/
    @objc func hrTimerfire() {
        let hrVal = HRObj.fetchLatestHrReading()
        
        // Verify theree is a recent reading.
        if hrVal == -1 {
            self.setHRButtonValue(labelValue: "-")
            return
        } else {
            self.setHRButtonValue(labelValue: "\(hrVal)")
        }
        
        // Retrieve Threshold values
        let hrLowThreshold = UserDefaults.standard.getValue(key: UserDefaultKeys.hrThresholdLowKey.description)
        let hrHighThreshold = UserDefaults.standard.getValue(key: UserDefaultKeys.hrThresholdHighKey.description)
        
        // Set color of Text in UI
        if hrVal >= Int(hrHighThreshold ?? "100")! || hrVal <= Int(hrLowThreshold ?? "40")! {
            self.lblHeartRateValue.textColor = UIColor.FeButtonRed
        } else if (hrVal < Int(hrHighThreshold ?? "100")! && hrVal > Int(Double(Int(hrHighThreshold ?? "100")!) * 0.90)) || (hrVal < Int(hrLowThreshold ?? "40")! && hrVal < Int(Double(Int(hrLowThreshold ?? "40")!) * 1.10)) {
            self.lblHeartRateValue.textColor = UIColor.FeButtonOrange
        } else {
            self.lblHeartRateValue.textColor = UIColor.FeButtonGreen
        }
        print("HR Timer Val: \(hrVal) BPM")
    }
    
    /*--------------------------------------------------------------------
     //MARK: BloodOxTimerfire()
     - Description: Method to update Blood Oxygen.
     -------------------------------------------------------------------*/
    @objc func bloodOxTimerfire() {
        let bloodOxygen = BldOxObj.fetchLatestBloodOxReading()
        
        // Verify there is a recent reading
        if bloodOxygen == -1 {
            self.setBloodOxButtonValue(labelValue: "-")
            return
        } else {
            self.setBloodOxButtonValue(labelValue: "\(bloodOxygen)")
        }
        
        // Retrieve threshold values
        let bldOxLowThreshold = UserDefaults.standard.getValue(key: UserDefaultKeys.bldOxThresholdLowKey.description)
        let bldOxHighThreshold = UserDefaults.standard.getValue(key: UserDefaultKeys.bldOxThresholdHighKey.description)
        
        // Set color of text in UI
        if bloodOxygen > Int(bldOxHighThreshold ?? "100")! || bloodOxygen <= Int(bldOxLowThreshold ?? "90")! {
            self.lblBloodOxygenValue.textColor = UIColor.FeButtonRed
        } else if bloodOxygen < Int(bldOxLowThreshold ?? "90")! && bloodOxygen < Int(Double(Int(bldOxLowThreshold ?? "90")!) * 1.05) {
            self.lblBloodOxygenValue.textColor = UIColor.FeButtonOrange
        } else {
            self.lblBloodOxygenValue.textColor = UIColor.FeButtonGreen
        }
        print("Blood Ox Timer Val: \(bloodOxygen) %")
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
     //MARK: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func btnSocialAndGamificationTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToSocialAndGamification", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnMoreInfoTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func btnMoreInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnChatbotTapped()
     - Description: Segue to Chatbot Screen
     -------------------------------------------------------------------*/
    @IBAction func btnChatbotTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToChatbotScreen", sender: self)
        print("Chatbot button pressed")
    }
    
    /*--------------------------------------------------------------------
     //MARK: obtainLocationAuth()
     - Description: Requests access to location.
     -------------------------------------------------------------------*/
    func obtainLocationAuth() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

/*------------------------------------------------------------------------
 //MARK: AltitudeViewController : cLLocationManagerDelegate
 - Description: Methods for getting location for Elevation.
 -----------------------------------------------------------------------*/
extension HomeVC: CLLocationManagerDelegate {
    
    /*--------------------------------------------------------------------
     //MARK: locationManager()
     - Description: Gets last location altitude and displays on screen.
     -------------------------------------------------------------------*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let elevation = round(lastLocation.altitude)
            CDObj.createElevationDataTableEntry(eleValue: Float(elevation))
        }
    }
}
