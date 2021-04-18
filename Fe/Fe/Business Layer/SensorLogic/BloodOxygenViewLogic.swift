//
//  BloodOxygenViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

import Foundation
import Charts

class BloodOxygenViewLogic {
    let HKObj = HKAccessObject()
    
    func fetchLatestO2(completion: @escaping (_ o2Val: Int) -> Void) {
        HKObj.getLatestO2( completion: { (o2Val) -> Void in
            completion(Int(o2Val))
        })
    }
    
    func fetchHrWithRange(dateRange: String, completion: @escaping (_ dateArray: [String], _ o2Array: [Double], _ maxo2: Int, _ mino2: Int) -> Void) {
        HKObj.fetchHRData(dateRange: dateRange, completion: { o2Dict in
            DispatchQueue.main.async {
                let dateArray = Array(o2Dict.keys)
                let o2Array = Array(o2Dict.values)
                let o2Max = Int(o2Array.max() ?? 0)
                let o2Min = Int(o2Array.min() ?? 0)
                completion(dateArray, o2Array, o2Max, o2Min)
            }
        })
    }
    
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
