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
    let BldOxObj = BloodOxygenLogic()
    
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
        
        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxValue in
            self.lblCurrentO2.text = "Current Blood Oxygen: \(String(bloodOxValue)) %"
        })
        
        BldOxObj.fetchBloodOxWithRange(dateRange : "day", completion: { [self] dateArray, bldOxArray, bldOxMax, bldOxMin in
            lineChartView.data = BldOxObj.chartData(dataPoints: dateArray, values: bldOxArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 1
            self.lblMaxO2.text = "Maximum Blood Oxygen: \(Int(bldOxArray.max() ?? 0))"
            self.lblMinO2.text = "Minimum Blood Oxygen: \(Int(bldOxArray.min() ?? 0))"
        })
    }
}
