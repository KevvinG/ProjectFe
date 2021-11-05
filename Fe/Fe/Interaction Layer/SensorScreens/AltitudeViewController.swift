//
//  AltitudeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit
import Charts
import TinyConstraints

/*------------------------------------------------------------------------
 //MARK: AltitudeViewController : UIViewController
 - Description: Shows data for Blood Oxygen Sensor (past and current)
 -----------------------------------------------------------------------*/
class AltitudeViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var imgMountainAlt: UIImageView!
    @IBOutlet var lblCurrPressure: UILabel!
    @IBOutlet var lblAvgPressure: UILabel!
    @IBOutlet var lblMinPressure: UILabel!
    @IBOutlet var lblMaxPressure: UILabel!
    @IBOutlet var lblCurrElevation: UILabel!
    @IBOutlet var lblAvgElevation: UILabel!
    @IBOutlet var lblMinElevation: UILabel!
    @IBOutlet var lblMaxElevation: UILabel!
    @IBOutlet var elevationLineChart: LineChartView!
    @IBOutlet var apLineChart: LineChartView!
    
    // Class Variables
    let AltLogic = AltitudeLogic()
    let CDObj = CoreDataAccessObject()

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initChartAirPressure()
        initChartElevation()
        
//        AltLogic.fetchElevationWithRange(dateRange : "week", completion: { [self] dateArray, elevationArray in
//            elevationLineChart.data = AltLogic.chartData(dataPoints: dateArray, values: elevationArray)
//            elevationLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
//            elevationLineChart.xAxis.granularity = 0.05
//            elevationLineChart.xAxis.labelPosition = .bottom
//            elevationLineChart.xAxis.drawGridLinesEnabled = false
//            elevationLineChart.rightAxis.enabled = false
//            elevationLineChart.leftAxis.setLabelCount(6, force: false)
//            elevationLineChart.xAxis.labelCount = 4
//        })
        
//        AltLogic.fetchAirPressureWithRange(dateRange : "week", completion: { [self] dateArray, airPressureArray in
//            apLineChart.data = AltLogic.chartData(dataPoints: dateArray, values: airPressureArray)
//            apLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
//            apLineChart.xAxis.granularity = 0.05
//            apLineChart.xAxis.labelPosition = .bottom
//            apLineChart.xAxis.drawGridLinesEnabled = false
//            apLineChart.rightAxis.enabled = false
//            apLineChart.leftAxis.setLabelCount(6, force: false)
//            apLineChart.xAxis.labelCount = 4
//        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: initChartAirPressure()
     - Description: Initializes chart with data
     -------------------------------------------------------------------*/
    func initChartAirPressure() {
        
        var cdAPData = [AirPressureData]()
        var cdAirPressureData = [Double]()
        var cdDateData = [String]()
        cdAPData = CDObj.fetchAirPressureData()!
        
        for item in cdAPData {
            let df = DateFormatter()
            cdDateData.append(df.string(from: item.dateTime))
            cdAirPressureData.append(Double(item.airPressure))
        }
        
        apLineChart.data = AltLogic.chartData(dataPoints: cdDateData, values: cdAirPressureData)
        apLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: cdDateData)
        apLineChart.xAxis.granularity = 0.05
        
        apLineChart.xAxis.labelPosition = .bottom
        apLineChart.xAxis.drawGridLinesEnabled = false
        apLineChart.xAxis.setLabelCount(6, force: false)

        apLineChart.legend.enabled = false
        
        apLineChart.animate(xAxisDuration: 2)
        
        // Set up Stats
        lblCurrPressure.text = String(format: "\(fetchPressure()) hPa")
        
        let apMin = Int(cdAirPressureData.min() ?? -1)
        let apMax = Int(cdAirPressureData.max() ?? -1)
        var apSum = 0.0
        for item in cdAirPressureData {
            apSum+=item
        }
        if cdAirPressureData.count == 0 {
            self.lblAvgPressure.text = "-1 BPM"
        } else {
            let apAvg = Int(apSum/Double(cdAirPressureData.count))
            self.lblAvgPressure.text = "\(apAvg) BPM"
        }
        
        self.lblMaxPressure.text = "\(apMax) hPa"
        self.lblMinPressure.text = "\(apMin) hPa"
    }
    
    /*--------------------------------------------------------------------
     //MARK: initChartElevation()
     - Description: Initializes chart with data
     -------------------------------------------------------------------*/
    func initChartElevation() {
        
        var cdElevationData = [ElevationData]()
        var cdEleData = [Double]()
        var cdDateData = [String]()
        cdElevationData = CDObj.fetchElevationData()!
        
        for item in cdElevationData {
            let df = DateFormatter()
            cdDateData.append(df.string(from: item.dateTime))
            cdEleData.append(Double(item.elevation))
        }
        
        elevationLineChart.data = AltLogic.chartData(dataPoints: cdDateData, values: cdEleData)
        elevationLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: cdDateData)
        elevationLineChart.xAxis.granularity = 0.05
        
        elevationLineChart.xAxis.labelPosition = .bottom
        elevationLineChart.xAxis.drawGridLinesEnabled = false
        elevationLineChart.xAxis.setLabelCount(6, force: false)

        elevationLineChart.legend.enabled = false
        
        elevationLineChart.animate(xAxisDuration: 2)
        
        // Set up Stats
        lblCurrElevation.text = String(format: "\(fetchElevation()) meters")
        
        let eleMin = Int(cdEleData.min() ?? -1)
        let eleMax = Int(cdEleData.max() ?? -1)
        var eleSum = 0.0
        for item in cdEleData {
            eleSum+=item
        }
        if cdEleData.count == 0 {
            self.lblAvgElevation.text = "-1 meters"
        } else {
            let eleAvg = Int(eleSum/Double(cdEleData.count))
            self.lblAvgElevation.text = "\(eleAvg) meters"
        }
        
        self.lblMaxElevation.text = "\(eleMax) meters"
        self.lblMinElevation.text = "\(eleMin) meters"
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchPressure()
     - Description: Retrieves latest air pressure reading from Core Data.
     ---------------------.----------------------------------------------*/
    func fetchPressure() -> Float {
        return AltLogic.fetchLatestPressureReading()
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchElevation()
     - Description: Retrieves latest elevation reading from Core Data.
     -------------------------------------------------------------------*/
    func fetchElevation() -> Float {
        return AltLogic.fetchLatestElevationReading()
    }
}
