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
    let HRLogic = HeartRateLogic()

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
        
        HRLogic.fetchLatestHrReading(completion: { hrVal in
            self.lblCurrentHR.text = "Current Heart Rate: \(String(hrVal))"
        })

        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMin in
            
            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 0.05
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.xAxis.drawGridLinesEnabled = false
    
            self.lblMaxHR.text = "Maximum HR: \(Int(bpmArray.max() ?? 0)) BPM"
            self.lblMinHR.text = "Minimum HR: \(Int(bpmArray.min() ?? 0)) BPM"
        })
    }
}

