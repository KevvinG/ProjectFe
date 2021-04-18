//
//  HeartRateViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

import Foundation

class HeartRateViewLogic {
    let HKObj = HKAccessObject()
    var dataDict : [String:Double] = [:]
    //var testDataDict : [Date:Double] = [:]
    
    func fetchLatestHR(completion: @escaping (_ hrVal: Int) -> Void) {
        HKObj.getLatestHR( completion: { (hrVal) -> Void in
            completion(hrVal)
        })
    }
    
    func fetchHrWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ bpmArray: [Double], _ maxBPM: Int, _ minBPM: Int) -> Void) {
        HKObj.fetchHealthData(dateRange: dateRange, completion: { bpmDict in
            DispatchQueue.main.async {
                //self.dataDict = bpmDict
                let dateArray = Array(bpmDict.keys)
                let bpmArray = Array(bpmDict.values)
                let bpmMax = Int(bpmArray.max() ?? 0)
                let bpmMin = Int(bpmArray.min() ?? 0)
//                self.customizeChart(dataPoints: dateArray, values: bpmArray)
//                self.lblMaxHR.text = "Maximum HR: \(Int(bpmArray.max() ?? 0)) BPM"
//                self.lblMinHR.text = "Minimum HR: \(Int(bpmArray.min() ?? 0)) BPM"
                completion(dateArray, bpmArray, bpmMax, bpmMin)
            }
        })
    }
    
    
    
}
