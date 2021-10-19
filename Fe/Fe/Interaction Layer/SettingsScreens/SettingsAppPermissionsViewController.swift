//
//  SettingsAppPermissionsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-13.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: SettingsAppPermissionsViewController : UIViewController
 - Description: Holds the logic to control what permissions are allowed.
 -----------------------------------------------------------------------*/
class SettingsAppPermissionsViewController: UIViewController {
    
    // Class Variables
    let AppLogic = AppPermissionsLogic()
    
    // UI Variables
    @IBOutlet var swGPS: UISwitch!
    @IBOutlet var swAltimeter: UISwitch!
    @IBOutlet var swHeartRate: UISwitch!
    @IBOutlet var swBloodOxygen: UISwitch!
    @IBOutlet var sw911Emgcy: UISwitch!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     //MARK: swGPSStateChanged()
     - Description: Logic for changing GPS Permission.
     -------------------------------------------------------------------*/
    @IBAction func swGPSStateChanged(_ sender: UISwitch) {
        if swGPS.isOn {
            print("GPS Switch is on.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swGPSSensorKey.description, value: true)
            //TODO: Ask for permission
        } else {
            print("GPS Switch is off.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swGPSSensorKey.description, value: false)
            //TODO: Change permission
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swAltimeterStateChanged()
     - Description: Logic for changing Altimeter Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swAltimeterStateChanged(_ sender: Any) {
        if swAltimeter.isOn {
            print("Altimeter Switch is on.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swAltimeterSensorKey.description, value: true)
            //TODO: Ask for permission
        } else {
            print("Altimeter Switch is off.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swAltimeterSensorKey.description, value: false)
            //TODO: Change permission
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swHeartRateStateChanged()
     - Description: Logic for changing Heart Rate Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swHeartRateStateChanged(_ sender: Any) {
        if swHeartRate.isOn {
            print("Heart Rate Switch is on.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swHeartRateSensorKey.description, value: true)
            //TODO: Ask for permission
        } else {
            print("Heart Rate Switch is off.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swHeartRateSensorKey.description, value: false)
            //TODO: Change permission
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBloodOxygenStateChanged()
     - Description: Logic for changing Blood Oxygen Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swBloodOxStateChanged(_ sender: Any) {
        if swBloodOxygen.isOn {
            print("Blood Oxygen Switch is on.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swBloodOxygeenSensorKey.description, value: true)
            //TODO: Ask for permission
        } else {
            print("Blood Oxygen Switch is off.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swBloodOxygeenSensorKey.description, value: false)
            //TODO: Change permission
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: sw911EmgcyStateChanged()
     - Description: Logic for changing coontacting 911 in event
     of emergency Permission.
     -------------------------------------------------------------------*/
    @IBAction func sw911EmgcyStateChanged(_ sender: Any) {
        if sw911Emgcy.isOn {
            print("Contact 911 in Emergency Switch is on.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swContact911EmergencyKey.description, value: true)
        } else {
            print("Contact 911 in Emergency Switch is off.")
            AppLogic.updateSwitchState(key: UserDefaultKeys.swContact911EmergencyKey.description, value: false)
        }
    }
}
