//
//  SettingsAppPermissionsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-13.
//

//MARK: Imports
import UIKit
import CoreLocation

/*------------------------------------------------------------------------
 //MARK: SettingsSensorsViewController : UIViewController
 - Description: Holds the logic to control what sensors are allowed.
 -----------------------------------------------------------------------*/
class SettingsSensorsViewController: UIViewController, CLLocationManagerDelegate {
    
    // Class Variables
    let AppLogic = SettingsSensorsLogic()
    var locationManager: CLLocationManager?
    
    // UI Variables
    @IBOutlet var swAltimeter: UISwitch!
    @IBOutlet var swHeartRate: UISwitch!
    @IBOutlet var swBloodOxygen: UISwitch!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swAltimeter.setOn(AppLogic.setSwitchStateInUI(key: UserDefaultKeys.swAltimeterSensorKey.description), animated: false)
        swHeartRate.setOn(AppLogic.setSwitchStateInUI(key: UserDefaultKeys.swHeartRateSensorKey.description), animated: false)
        swBloodOxygen.setOn(AppLogic.setSwitchStateInUI(key: UserDefaultKeys.swBloodOxygenSensorKey.description), animated: false)
    }
    
    /*--------------------------------------------------------------------
     //MARK: swAltimeterStateChanged()
     - Description: Logic for changing Altimeter Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swAltimeterStateChanged(_ sender: Any) {
        if swAltimeter.isOn {
            print("Altimeter Switch is on.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swAltimeterSensorKey.description, value: true)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swAltimeterSensorKey.description, value: "true")
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
        } else {
            print("Altimeter Switch is off.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swAltimeterSensorKey.description, value: false)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swAltimeterSensorKey.description, value: "false")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swHeartRateStateChanged()
     - Description: Logic for changing Heart Rate Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swHeartRateStateChanged(_ sender: Any) {
        if swHeartRate.isOn {
            print("Heart Rate Switch is on.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swHeartRateSensorKey.description, value: true)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swHeartRateSensorKey.description, value: "true")
        } else {
            print("Heart Rate Switch is off.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swHeartRateSensorKey.description, value: false)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swHeartRateSensorKey.description, value: "false")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBloodOxygenStateChanged()
     - Description: Logic for changing Blood Oxygen Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swBloodOxStateChanged(_ sender: Any) {
        if swBloodOxygen.isOn {
            print("Blood Oxygen Switch is on.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: true)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: "true")
        } else {
            print("Blood Oxygen Switch is off.")
            AppLogic.updateSwitchInUserDefaults(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: false)
            AppLogic.updateSwitchInFB(key: UserDefaultKeys.swBloodOxygenSensorKey.description, value: "false")
        }
    }
}
