//
//  BloodOxygenViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-27

// Imports
import UIKit
import Charts

/*------------------------------------------------------------------------
 - Class: BloodOxygenViewController : UIViewController
 - Description: Shows data for Blood Oxygen Sensor (past and current)
 -----------------------------------------------------------------------*/
class BloodOxygenViewController: UIViewController {
    
    // Class Variables
    let HRLogic = HeartRateViewLogic()
    
    // UI Variables
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet var lblMaxO2: UILabel!
    @IBOutlet var lblMinO2: UILabel!
    @IBOutlet var lblCurrentO2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HRLogic.fetchLatestHR(completion: {hrVal in
            self.lblCurrentO2.text = "Current Oxygen Saturation Rate: \(String(hrVal))"
        })
        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMix in
            
            self.customizeChart(dataPoints: dateArray, values: bpmArray)
            self.lblMaxO2.text = "Maximum HR: \(Int(bpmArray.max() ?? 0)) BPM"
            self.lblMinO2.text = "Minimum HR: \(Int(bpmArray.min() ?? 0)) BPM"
        })
        
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
}
