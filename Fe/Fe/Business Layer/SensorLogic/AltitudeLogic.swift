//
//  AltitudeViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation
import CoreMotion
import Charts

/*------------------------------------------------------------------------
 //MARK: Class AltitudeLogic
 - Description: Holds logic for the Altitude
 -----------------------------------------------------------------------*/
class AltitudeLogic {
    
    // Class Variables
    let PhoneObj = PhoneSensorObject()
    let CDObj = CoreDataAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: fetchPressureReading()
     - Description: Obtains pressure reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchLatestPressureReading() -> Float {
        return CDObj.fetchLatestAirPressure()
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchElevationReading()
     - Description: Obtains clevation reading from Phone Sensor Object.
     -------------------------------------------------------------------*/
    func fetchLatestElevationReading() -> Float {
        return CDObj.fetchLatestElevation()
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchAirPressureWithRange()
     - Description: Obtains air pressure data in range
     -------------------------------------------------------------------*/
    func fetchAirPressureWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ AirPressureArray: [Double]) -> Void) {
        
        let apItems = CDObj.fetchAirPressureData()
        var dateArray = [String]()
        var airPressureArray = [Double]()
        var outputSpacing = apItems!.count/2
        if outputSpacing == 0 {
            outputSpacing = 1
        }
        if apItems != nil && apItems!.count > 0 {
            var i=1
            for item in 0..<(apItems!.count-1) {
                let df = DateFormatter()
                df.dateFormat = "dd/MM/YY"
                let date = df.string(from: apItems![item].dateTime)
                if i % outputSpacing != 0 {
                    dateArray.append(date)
                    
                    let airPressure = Double(apItems![item].airPressure)
                    airPressureArray.append(airPressure)
                }
                i+=1
            }
        }
        completion(dateArray, airPressureArray)
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchElevationWithRange()
     - Description: Obtains elevation data in range.
     -------------------------------------------------------------------*/
    func fetchElevationWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ elevationArray: [Double]) -> Void) {
        
        let elevationItems = CDObj.fetchElevationData()
        var dateArray = [String]()
        var elevationArray = [Double]()
        var outputSpacing = elevationItems!.count/2
        if outputSpacing == 0 {
            outputSpacing = 1
        }
        if elevationItems != nil && elevationItems!.count > 0 {
            var i=1
            for item in 0..<(elevationItems!.count-1) {
                let df = DateFormatter()
//                df.dateFormat = "HH:mm E, d MMM y"
                df.dateFormat = "dd/MM/YY"
                let date = df.string(from: elevationItems![item].dateTime)
                if i % outputSpacing != 0 {
                dateArray.append(date)
                
                let elevation = Double(elevationItems![item].elevation)
                elevationArray.append(elevation)
                }
                i+=1
            }
        }
        completion(dateArray, elevationArray)
    }
    
    /*--------------------------------------------------------------------
     //MARK: chartData()
     - Description: Obtains chart data from Core Data
     -------------------------------------------------------------------*/
    func chartData(dataPoints: [String], values: [Double]) -> LineChartData {
        var dataEntries : [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.setColor(.systemRed)
        lineChartDataSet.highlightColor = .systemRed
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        return lineChartData
    }
}
