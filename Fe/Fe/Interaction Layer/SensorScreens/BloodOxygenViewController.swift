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
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HRLogic.fetchLatestHR(completion: { hrVal in
            self.lblCurrentO2.text = "Current Oxygen Saturation Rate: \(String(hrVal))"
        })
        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMix in
            
            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 1
            self.lblMaxO2.text = "Maximum O2: \(Int(bpmArray.max() ?? 0))"
            self.lblMinO2.text = "Minimum O2: \(Int(bpmArray.min() ?? 0))"
        })
    }
}
