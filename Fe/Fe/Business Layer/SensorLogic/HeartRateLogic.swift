//
//  HeartRateViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation
import Charts

/*------------------------------------------------------------------------
 //MARK: Class HeartRateViewLogic
 - Description: Holds logic for the Heart Rate
 -----------------------------------------------------------------------*/
class HeartRateLogic {
    
    // Class Variables
    let HKObj = HKAccessObject()
    let CDObj = CoreDataAccessObject()
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: getUserHrThresholds()
     - Description: Calls Firebase method and displays data in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserHrThresholds(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getUserHrThresholds(completion: { thresholds in
            completion(thresholds)
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateHrThresholds()
     - Description: Sends Threshold values to Firebase Access Object.
     -------------------------------------------------------------------*/
    func updateHrThresholds(lowThreshold: String, highThreshold: String, completion: @escaping (_ success: Bool) -> Void) {
        FBObj.updateHrThresholds(lowThreshold: lowThreshold, highThreshold: highThreshold, completion: { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestHrReading()
     - Description: Obtains the latest heart rate value from Core Data.
     -------------------------------------------------------------------*/
    func fetchLatestHrReading() -> Int {
        return CDObj.fetchLatestHR()
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHrWithRange()
     - Description: Obtains heart rate values from Health Store for Chart.
     -------------------------------------------------------------------*/
    func fetchHrWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bpmArray: [Double], _ maxBPM: Int, _ minBPM: Int, _ avgBPM: Int) -> Void) {
        HKObj.getHrChartData(dateRange: dateRange, completion: { bpmDict in
            DispatchQueue.main.async {
                var testDict = bpmDict
                let dictCount = testDict.count
                var outputSpacing = dictCount/12
                if outputSpacing == 0 {
                    outputSpacing = 1
                }
                var i = 1
                for element in testDict {
                    if i % outputSpacing != 0 {
                        testDict.removeValue(forKey: element.key)
                    }
                    i+=1
                }
                let dateArray = Array(testDict.keys)
                var newDateArray : [String] = []
                for element in dateArray{
                    newDateArray.append(self.convertDate(element, dateRange: dateRange))
                }
                let bpmArray = Array(testDict.values)
                let bpmMax = Int(bpmArray.max() ?? 0)
                let bpmMin = Int(bpmArray.min() ?? 0)
                let sum = Int(bpmArray.reduce(0, +))
                let count = bpmArray.count
                var bpmAvg = 0
                if count > 0 {
                    bpmAvg = sum / count
                }
                completion(newDateArray, bpmArray, bpmMax, bpmMin, bpmAvg)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHrWithRangeCD
     - Description: CoreData fetching of data with a range
     -------------------------------------------------------------------*/
   func fetchHrWithRangeCD(dateRange: String, completion: @escaping (_ dateArray: [String], _ bpmArray: [Double], _ maxBPM: Int, _ minBPM: Int, _ avgBPM: Int) -> Void) {
       CDObj.getHrChartData(dateRange: dateRange, completion: { bpmDict in
           DispatchQueue.main.async {
               var testDict = bpmDict
               let dictCount = testDict.count
               var outputSpacing = dictCount/12
               if outputSpacing == 0 {
                   outputSpacing = 1
               }
               var i = 1
               for element in testDict {
                   if i % outputSpacing != 0 {
                       testDict.removeValue(forKey: element.key)
                   }
                   i+=1
               }
               let dateArray = Array(testDict.keys)
               var newDateArray : [String] = []
               for element in dateArray{
                   newDateArray.append(self.convertDate(element, dateRange: dateRange))
               }
               let bpmArray = Array(testDict.values)
               let bpmMax = Int(bpmArray.max() ?? 0)
               let bpmMin = Int(bpmArray.min() ?? 0)
               let sum = Int(bpmArray.reduce(0, +))
               let count = bpmArray.count
               var bpmAvg = 0
               if count > 0 {
                   bpmAvg = sum / count
               }
               completion(newDateArray, bpmArray, bpmMax, bpmMin, bpmAvg)
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
        if dateRange == "day" {
            dateFormatter.dateFormat = "HH:mm"
        } else if dateRange == "month" {
            dateFormatter.dateFormat = "dd/MM/YY"
        }
        
        let currentDate = Date()
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
