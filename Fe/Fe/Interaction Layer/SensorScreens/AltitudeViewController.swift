//
//  AltitudeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit
import CoreLocation

/*------------------------------------------------------------------------
 - Class: AltitudeViewController : UIViewController
 - Description: Shows data for Blood Oxygen Sensor (past and current)
 -----------------------------------------------------------------------*/
class AltitudeViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var imgMountainAlt: UIImageView!
    @IBOutlet var lblCurrPressure: UILabel!
    @IBOutlet var lblCurrElevation: UILabel!
    
    
    // Class Variables
    let AltLogic = AltitudeViewLogic()
    let locationManager = CLLocationManager()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        obtainLocationAuth()
        fetchPressure()
        fetchAltitude()
        
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchPressure()
     - Description: Obtains current air pressure from business layer.
     -------------------------------------------------------------------*/
    func fetchPressure() {
        AltLogic.fetchPressureReading(completion: { (pressure) in
            self.lblCurrPressure.text = "Current Pressure: \(pressure) hPa"
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchAltitude()
     - Description:
     -------------------------------------------------------------------*/
    func fetchAltitude() {
    }
    
    /*--------------------------------------------------------------------
     - Function: obtainLocationAuth()
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


extension AltitudeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let elevation = round(lastLocation.altitude)
            lblCurrElevation.text = String(format: "Current Elevation: \(elevation) meters")
        }
    }
}
