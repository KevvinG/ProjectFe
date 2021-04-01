//
//  AltitudeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit
import CoreLocation
import CoreMotion

/*------------------------------------------------------------------------
 - Class: AltitudeViewController : UIViewController
 - Description: Shows data for Blood Oxygen Sensor (past and current)
 -----------------------------------------------------------------------*/
class AltitudeViewController: UIViewController {
    @IBOutlet var lblAlt: UILabel!
    @IBOutlet var btnCapture: UIButton!
    private let locationManager = CLLocationManager()
    let altimeter = CMAltimeter()


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
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // 2
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                // 3
                if (error == nil) {
                    print("Relative Altitude: \(data?.relativeAltitude)")
                    print("Pressure: \(data?.pressure)")
                    self.lblAlt.text = ("Relative Altitude: \(data?.relativeAltitude)")
                } else {
                    print("ERR \(error)")
                }
            })
        } else {
            print("No altitude available")
        }
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
