//
//  BloodOxygenViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

// Imports
import Foundation
import Charts

/*------------------------------------------------------------------------
 - Class: BloodOxygenViewLogic
 - Description: Holds logic for the Blood Oxygen
 -----------------------------------------------------------------------*/
class BloodOxygenLogic {
    
    // Class Variables
    let HKObj = HKAccessObject()
    
    /*--------------------------------------------------------------------
     - Function: fetchLatestBloodOxReading()
     - Description: Obtains blood oxygen reading from health store.
     -------------------------------------------------------------------*/
    func fetchLatestBloodOxReading(completion: @escaping (_ bloodOxValue: Int) -> Void) {
        HKObj.getLatestbloodOxReading( completion: { (bloodOxValue) -> Void in
            completion(Int(bloodOxValue))
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: fetchBloodOxWithRange()
     - Description: Obtains blood oxygen values from Health Store for Chart.
     -------------------------------------------------------------------*/
    func fetchBloodOxWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bldOxArray: [Double], _ bldOxMax: Int, _ bldOxMin: Int) -> Void) {
        HKObj.getBloodOxChartData(dateRange: dateRange, completion: { o2Dict in
            DispatchQueue.main.async {
                let dateArray = Array(o2Dict.keys)
                let bldOxArray = Array(o2Dict.values)
                let bldOxMax = Int(bldOxArray.max() ?? 0)
                let bldOxMin = Int(bldOxArray.min() ?? 0)
                completion(dateArray, bldOxArray, bldOxMax, bldOxMin)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     - Function: chartData()
     - Description: Sets up the Chart for blood oxygen.
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
