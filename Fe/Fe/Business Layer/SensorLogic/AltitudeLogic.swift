//
//  AltitudeViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

// Imports
import Foundation
import CoreMotion
import Charts

/*------------------------------------------------------------------------
 - Class: AltitudeViewLogic
 - Description: Holds logic for the Altitude
 -----------------------------------------------------------------------*/
class AltitudeLogic {
    
    // Class Variables
    let phoneObj = PhoneSensorObject()
    let coredataObj = CoreDataAccessObject()
    
    /*--------------------------------------------------------------------
     - Function: fetchPressureReading()
     - Description: Obtains pressure reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchPressureReading(completion: @escaping (_ pressure: String) -> Void) {
        phoneObj.fetchPressure(completion: { (pressure) -> Void in
            // Save Value received if valid
            if pressure != "NA" {
                DispatchQueue.main.async {
                    self.coredataObj.createAirPressureDataTableEntry(apValue: Float(pressure)!)
                }
            }
            completion(pressure)
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchElevationReading()
     - Description: Obtains clevation reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchElevationReading(completion: @escaping (_ elevatioon: String) -> Void) {
        phoneObj.fetchElevation(completion: { (elevation) -> Void in
            completion(elevation)
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchAirPressureWithRange()
     - Description: Obtains air pressure data in range
     -------------------------------------------------------------------*/
    func fetchAirPressureWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ AirPressureArray: [Double]) -> Void) {
        
        let apItems = self.coredataObj.fetchAirPressureData()
        var dateArray = [String]()
        var airPressureArray = [Double]()
        if apItems != nil && apItems!.count > 0 {
            for item in 0..<(apItems!.count-1) {
                let df = DateFormatter()
                df.dateFormat = "HH:mm E, d MMM y"
                let date = df.string(from: apItems![item].dateTime)
                dateArray.append(date)
                
                let airPressure = Double(apItems![item].airPressure)
                airPressureArray.append(airPressure)
            }
        }
        completion(dateArray, airPressureArray)
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchElevationWithRange()
     - Description: Obtains elevation data in range.
     -------------------------------------------------------------------*/
    func fetchElevationWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ elevationArray: [Double]) -> Void) {
        
        let elevationItems = self.coredataObj.fetchElevationData()
        var dateArray = [String]()
        var elevationArray = [Double]()
        if elevationItems != nil && elevationItems!.count > 0 {
            for item in 0..<(elevationItems!.count-1) {
                let df = DateFormatter()
                df.dateFormat = "HH:mm E, d MMM y"
                let date = df.string(from: elevationItems![item].dateTime)
                dateArray.append(date)
                
                let elevation = Double(elevationItems![item].elevation)
                elevationArray.append(elevation)
            }
        }
        completion(dateArray, elevationArray)
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchAirPresssureChartData()
     - Description: Obtains air pressure chart data from Core data
     -------------------------------------------------------------------*/
    func chartData(dataPoints: [String], values: [Double]) -> LineChartData {
        var dataEntries : [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        return lineChartData
    }
}
