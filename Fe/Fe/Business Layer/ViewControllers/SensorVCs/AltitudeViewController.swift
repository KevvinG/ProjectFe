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
    @IBOutlet var lblAlt: UILabel!
    @IBOutlet var btnCapture: UIButton!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    @IBAction func btnPressCapture(_ sender: Any) {
//        self.locationManager = CLLocationManager()
//        locationManager.requestWhenInUseAuthorization()
//        self.locationManager.delegate = self
//        self.locationManager.distanceFilter = kCLDistanceFilterNone
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.startUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
//       var alt = newLocation.altitude
//       print("\(alt)")
//       manager.stopUpdatingLocation()
//    }
}

extension AltitudeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let altitude = lastLocation.altitude
            lblAlt.text = String(format: "My altitude is\n%.1f m", altitude)
        }
    }
}
