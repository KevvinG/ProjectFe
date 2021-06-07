//
//  HeartRateViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

// Imports
import Foundation
import Charts

/*------------------------------------------------------------------------
 - Class: HeartRateViewLogic
 - Description: Holds logic for the Heart Rate
 -----------------------------------------------------------------------*/
class HeartRateLogic {
    
    // Class Variables
    let HKObj = HKAccessObject()
    let CDObj = CoreDataAccessObject()
    var dataDict: [String:Double] = [:]
    
    /*--------------------------------------------------------------------
     - Function: fetchLatestHrReading()
     - Description: Obtains the latest heart rate value from Core Data.
     -------------------------------------------------------------------*/
    func fetchLatestHrReading() -> Int {
//        HKObj.getLatestHR( completion: { (hrVal) -> Void in
//            completion(hrVal)
//        })
        return CDObj.fetchLatestHR()
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchHrWithRange()
     - Description: Obtains heart rate values from Health Store for Chart.
     -------------------------------------------------------------------*/
    func fetchHrWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bpmArray: [Double], _ maxBPM: Int, _ minBPM: Int) -> Void) {
        HKObj.getHrChartData(dateRange: dateRange, completion: { bpmDict in
            DispatchQueue.main.async {
                let dateArray = Array(bpmDict.keys)
                let bpmArray = Array(bpmDict.values)
                let bpmMax = Int(bpmArray.max() ?? 0)
                let bpmMin = Int(bpmArray.min() ?? 0)
                completion(dateArray, bpmArray, bpmMax, bpmMin)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: chartData()
     - Description: Sets up the Chart for heart rate.
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
