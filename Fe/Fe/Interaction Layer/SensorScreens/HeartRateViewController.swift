//
//  HeartRateViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-26

// Imports
import UIKit
import Charts

/*------------------------------------------------------------------------
 - Class: HeartRateViewController : UIViewController
 - Description: Holds logic for the Heart Rate Screen
 -----------------------------------------------------------------------*/
class HeartRateViewController: UIViewController {
    // Class Variables
//    let HKObj = HKAccessObject()
//    var dataDict : [String:Double] = [:]
//    var testDataDict : [Date:Double] = [:]
    
//    var plotData = [Double](repeating: 0.0, count: 1000)
//    var maxDataPoints = 100
//    var frameRate = 5.0
//    var alphaValue = 0.25
//    var timer : Timer?
//    var currentIndex: Int!
//    var timeDuration:Double = 0.1
    let HRLogic = HeartRateViewLogic()

    
    // UI Variables
    @IBOutlet var lblCurrentHR: UILabel!
    @IBOutlet var lblMinHR: UILabel!
    @IBOutlet var lblMaxHR: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HRLogic.fetchLatestHR(completion: {hrVal in
            self.lblCurrentHR.text = "Current Heart Rate: \(String(hrVal))"
        })
//        HKObj.getLatestHR(completion: { hrVal in
//            self.lblCurrentHR.text = "Current Heart Rate: \(String(hrVal))"
//        })
        
        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMix in
            
            self.customizeChart(dataPoints: dateArray, values: bpmArray)
            self.lblMaxHR.text = "Maximum HR: \(Int(bpmArray.max() ?? 0)) BPM"
            self.lblMinHR.text = "Minimum HR: \(Int(bpmArray.min() ?? 0)) BPM"
        })
        
//        HKObj.fetchHealthData(dateRange: "day", completion: { [self] bpmDict in
//            DispatchQueue.main.async {
//                self.dataDict = bpmDict
//                let dateArray = Array(self.dataDict.keys)
//                let bpmArray = Array(self.dataDict.values)
//                self.customizeChart(dataPoints: dateArray, values: bpmArray)
//                self.lblMaxHR.text = "Maximum HR: \(Int(bpmArray.max() ?? 0)) BPM"
//                self.lblMinHR.text = "Minimum HR: \(Int(bpmArray.min() ?? 0)) BPM"
//            }
//        })
    }
    
    /*--------------------------------------------------------------------
     - Function: customizeChart()
     - Description: Creates Line Chart on screen with Heart Rate Data.
     -------------------------------------------------------------------*/
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
      
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        

      
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.xAxis.granularity = 1
    }
    
//    func receiveData(hrVal: Double) {
//        testDataDict[Date()] = hrVal
//        
//    }
    
}

