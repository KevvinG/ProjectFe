//
//  AltitudeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit
import CoreLocation
import Charts

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
    @IBOutlet var elevationLineChart: LineChartView!
    @IBOutlet var apLineChart: LineChartView!
    
    // Class Variables
    let AltLogic = AltitudeLogic()
    let CDObj = CoreDataAccessObject()
    let locationManager = CLLocationManager()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        obtainLocationAuth()
        fetchPressure()
//        fetchElevation()
        
        AltLogic.fetchAirPressureWithRange(dateRange : "day", completion: { [self] dateArray, airPressureArray in
//
            apLineChart.data = AltLogic.chartData(dataPoints: dateArray, values: airPressureArray)
            apLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            apLineChart.xAxis.granularity = 0.05
            apLineChart.xAxis.labelPosition = .bottom
            apLineChart.xAxis.drawGridLinesEnabled = false
        })
        
        AltLogic.fetchElevationWithRange(dateRange : "day", completion: { [self] dateArray, elevationArray in
            
            elevationLineChart.data = AltLogic.chartData(dataPoints: dateArray, values: elevationArray)
            elevationLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            elevationLineChart.xAxis.granularity = 0.05
            elevationLineChart.xAxis.labelPosition = .bottom
            elevationLineChart.xAxis.drawGridLinesEnabled = false
        })
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
     - Function: fetchElevation()
     - Description: Retrieves latest elevation reading from phone.
     -------------------------------------------------------------------*/
    func fetchElevation() {
        AltLogic.fetchElevationReading(completion: { (elevation) in
            self.lblCurrElevation.text = "Current Elevation: \(elevation) meters"
        })
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

/*------------------------------------------------------------------------
 - Extension: AltitudeViewController : cLLocationManagerDelegate
 - Description: Methods for getting location for Elevation.
 -----------------------------------------------------------------------*/
extension AltitudeViewController: CLLocationManagerDelegate {
    
    /*--------------------------------------------------------------------
     - Function: locationManager()
     - Description: Gets last location altitude and displays on screen.
     -------------------------------------------------------------------*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let elevation = round(lastLocation.altitude)
            CDObj.createElevationDataTableEntry(eleValue: Float(elevation))
            lblCurrElevation.text = String(format: "Current Elevation: \(elevation) meters")
        }
    }
}
