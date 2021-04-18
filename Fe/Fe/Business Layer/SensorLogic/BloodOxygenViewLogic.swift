//
//  BloodOxygenViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

import Foundation

class BloodOxygenViewLogic {
    let HKObj = HKAccessObject()
    var dataDict : [String:Double] = [:]
    //var testDataDict : [Date:Double] = [:]
    
    func fetchLatestO2(completion: @escaping (_ o2Val: Int) -> Void) {
        HKObj.getLatestO2( completion: { (o2Val) -> Void in
            completion(o2Val)
        })
    }
    
    func fetchHrWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ o2Array: [Double], _ maxo2: Int, _ mino2: Int) -> Void) {
        HKObj.fetchHRData(dateRange: dateRange, completion: { bpmDict in
            DispatchQueue.main.async {
                let dateArray = Array(o2Dict.keys)
                let o2Array = Array(o2Dict.values)
                let o2Max = Int(o2Array.max() ?? 0)
                let o2Min = Int(o2Array.min() ?? 0)
                completion(dateArray, o2Array, o2Max, o2Min)
            }
        })
    }
    
    
    
}
