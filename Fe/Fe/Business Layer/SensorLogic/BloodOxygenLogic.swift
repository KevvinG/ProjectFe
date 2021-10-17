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
//    func fetchLatestBloodOxReading(completion: @escaping (_ bloodOxValue: Int) -> Void) {
//        HKObj.getLatestbloodOxReading( completion: { (bloodOxValue) -> Void in
//            completion(Int(bloodOxValue))
//        })
//    }
    
    func fetchLatestBloodOxReading() -> Int {
        return CDObj.fetchLatestSPO2()
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchBloodOxWithRange()
     - Description: Obtains blood oxygen values from Health Store for Chart.
     -------------------------------------------------------------------*/
    func fetchBloodOxWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bldOxArray: [Double], _ bldOxMax: Int, _ bldOxMin: Int, _ bldOxAvg: Int) -> Void) {
        HKObj.getBloodOxChartData(dateRange: dateRange, completion: { bldOxDict in
            DispatchQueue.main.async {
                //let dateArray = Array(bldOxDict.keys)
                //let bldOxArray = Array(bldOxDict.values)
                var outputDict = bldOxDict
                let outputCount = outputDict.count
                var outputSpacing = outputCount/12
                if outputSpacing == 0 {
                    outputSpacing = 1
                }
                var i=1
                for element in outputDict {
                    if i % outputSpacing != 0 {
                        outputDict.removeValue(forKey: element.key)
                        print("Item removed")
                    }
                    i+=1
                    print(i)
                }
                let dateArray = Array(outputDict.keys)
                var outputDates : [String] = []
                for element in dateArray {
                    outputDates.append(self.convertDate(element, dateRange: dateRange))
                }
                let bldOxArray = Array(outputDict.values)
                
                let sum = Int(bldOxArray.reduce(0, +))
                let count = bldOxArray.count
                var bldOxAvg = 0
                if count > 0 {
                    bldOxAvg = sum / count
                }
                let bldOxMax = Int(bldOxArray.max() ?? 0)
                let bldOxMin = Int(bldOxArray.min() ?? 0)
                completion(dateArray, bldOxArray, bldOxMax, bldOxMin, bldOxAvg)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: convertDate()
     - Description: Converts the date stored in the database to one more user readable
     -------------------------------------------------------------------*/
    
    func convertDate(_ date: String, dateRange: String) -> String {

        let dateFormatter = DateFormatter()
        let formatDate = dateFormatter.date(from: date)

        // Set Date Format
        if dateRange == "day"{
            dateFormatter.dateFormat = "HH:mm"
        }else if dateRange == "month"{
            dateFormatter.dateFormat = "dd/MM/YY"
        }
        
        let currentDate = Date()
        // Convert Date to String
        return dateFormatter.string(from: formatDate ?? currentDate)
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
