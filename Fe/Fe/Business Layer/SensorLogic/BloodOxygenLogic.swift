//
//  BloodOxygenViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation
import Charts

/*------------------------------------------------------------------------
 //MARK: Class BloodOxygenViewLogic
 - Description: Holds logic for the Blood Oxygen
 -----------------------------------------------------------------------*/
class BloodOxygenLogic {
    
    // Class Variables
    let HKObj = HKAccessObject()
    let CDObj = CoreDataAccessObject()
    let FBOObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: getUserBldOxThresholds()
     - Description: Calls Firebase method and displays data in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserBldOxThresholds(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBOObj.getUserBldOxThresholds(completion: { thresholds in
            completion(thresholds)
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateBldOxThresholds()
     - Description: Sends Threshold values to Firebase Access Object.
     -------------------------------------------------------------------*/
    func updateBldOxThresholds(lowThreshold: String, highThreshold: String, completion: @escaping (_ success: Bool) -> Void) {
        FBOObj.updateBldOxThresholds(lowThreshold: lowThreshold, highThreshold: highThreshold, completion: { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestBloodOxReading()
     - Description: Obtains blood oxygen reading from health store.
     -------------------------------------------------------------------*/
    func fetchLatestBloodOxReading(completion: @escaping (_ bloodOxValue: Int) -> Void) {
        HKObj.getLatestbloodOxReading( completion: { (bloodOxValue) -> Void in
            completion(Int(bloodOxValue))
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchBloodOxWithRange()
     - Description: Obtains blood oxygen values from Health Store for Chart.
     -------------------------------------------------------------------*/
    func fetchBloodOxWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bldOxArray: [Double], _ bldOxMax: Int, _ bldOxMin: Int) -> Void) {
        HKObj.getBloodOxChartData(dateRange: dateRange, completion: { bldOxDict in
            DispatchQueue.main.async {
                let dateArray = Array(bldOxDict.keys)
                let bldOxArray = Array(bldOxDict.values)
                let bldOxMax = Int(bldOxArray.max() ?? 0)
                let bldOxMin = Int(bldOxArray.min() ?? 0)
                completion(dateArray, bldOxArray, bldOxMax, bldOxMin)
            }
        })
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
