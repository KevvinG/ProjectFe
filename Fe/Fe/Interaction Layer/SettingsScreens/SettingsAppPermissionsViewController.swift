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
    
    // UI Variables
    @IBOutlet var swGPS: UISwitch!
    @IBOutlet var swTxtEmgcy: UISwitch!
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
        } else {
            print("GPS Switch is off.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swGPSStateChanged()
     - Description: Logic for changing contacting emergency contact Permission.
     -------------------------------------------------------------------*/
    @IBAction func swTxtEmergencyStateChanged(_ sender: Any) {
        if swTxtEmgcy.isOn {
            print("Text to Emergency Contact Switch is on.")
        } else {
            print("Text to Emergency Contact Switch is off.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swAltimeterStateChanged()
     - Description: Logic for changing Altimeter Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swAltimeterStateChanged(_ sender: Any) {
        if swAltimeter.isOn {
            print("Altimeter Switch is on.")
        } else {
            print("Altimeter Switch is off.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swHeartRateStateChanged()
     - Description: Logic for changing Heart Rate Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swHeartRateStateChanged(_ sender: Any) {
        if swHeartRate.isOn {
            print("Heart Rate Switch is on.")
        } else {
            print("Heart Rate Switch is off.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: swBloodOxygenStateChanged()
     - Description: Logic for changing Blood Oxygen Sensor Permission.
     -------------------------------------------------------------------*/
    @IBAction func swBloodOxStateChanged(_ sender: Any) {
        if swBloodOxygen.isOn {
            print("Blood Oxygen Switch is on.")
        } else {
            print("Blood Oxygen Switch is off.")
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
        } else {
            print("Contact 911 in Emergency Switch is off.")
        }
    }
    
}
