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
            df.dateFormat = "hh:mm"
            cdDateData.append(df.string(from: item.dateTime))
            cdAirPressureData.append(Double(item.airPressure))
        }
        
        //Configure chart data
        apLineChart.data = AltLogic.chartData(dataPoints: cdDateData, values: cdAirPressureData)
        let customFormatter = CustomFormatter()
        customFormatter.labels = cdDateData
        apLineChart.xAxis.valueFormatter = customFormatter
        apLineChart.xAxis.granularity = 0.05
        apLineChart.xAxis.labelPosition = .bottom
        apLineChart.xAxis.drawGridLinesEnabled = false
        apLineChart.xAxis.setLabelCount(6, force: false)
        apLineChart.legend.enabled = false
        apLineChart.animate(xAxisDuration: 2)
        
        // Set Current Air Pressure Reading
        let apVal = fetchPressure()
        let currLabel = apVal == -1 ? "- hPa" : "\(String(apVal)) hPa"
        self.lblCurrPressure.text = currLabel
        
        // Get Stats
        let apMin = Int(cdAirPressureData.min() ?? -1)
        let apMax = Int(cdAirPressureData.max() ?? -1)
        var apSum = 0.0
        for item in cdAirPressureData {
            apSum+=item
        }
        
        // Set Average Air Pressure
        let avgLabel = cdAirPressureData.count == 0 ? "- hPa" : "\(String(Int(apSum/Double(cdAirPressureData.count)))) hPa"
        self.lblAvgPressure.text = avgLabel
        
        // Set Max Air Pressure
        let maxLabel = apMax == -1 ? "- hPa" : "\(String(apMax)) hPa"
        self.lblMaxPressure.text = maxLabel
        
        // Set Min Air Pressure
        let minLabel = apMin == -1 ? "- hpa" : "\(String(apMin)) hPa"
        self.lblMinPressure.text = minLabel
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
            df.dateFormat = "hh:mm"
            cdDateData.append(df.string(from: item.dateTime))
            cdEleData.append(Double(item.elevation))
        }
        
        elevationLineChart.data = AltLogic.chartData(dataPoints: cdDateData, values: cdEleData)
        let customFormatter = CustomFormatter()
        customFormatter.labels = cdDateData
        elevationLineChart.xAxis.valueFormatter = customFormatter
        elevationLineChart.xAxis.granularity = 0.05
        elevationLineChart.xAxis.labelPosition = .bottom
        elevationLineChart.xAxis.drawGridLinesEnabled = false
        elevationLineChart.xAxis.setLabelCount(6, force: false)
        elevationLineChart.legend.enabled = false
        elevationLineChart.animate(xAxisDuration: 2)
        
        // Set Current Elevation Reading
        let eleVal = fetchElevation()
        let currLabel = eleVal == -1 ? "- meters" : "\(String(Int(eleVal))) meters"
        self.lblCurrElevation.text = currLabel
        
        // Get Stats
        let eleMin = Int(cdEleData.min() ?? -1)
        let eleMax = Int(cdEleData.max() ?? -1)
        var eleSum = 0.0
        for item in cdEleData {
            eleSum+=item
        }
        
        // Set Average Elevation
        let avgLabel = cdEleData.count == 0 ? "- meters" : "\(String(Int(eleSum/Double(cdEleData.count)))) meters"
        self.lblAvgElevation.text = avgLabel
        
        // Set Max Elevation
        let maxLabel = eleMax == -1 ? "- meters" : "\(String(eleMax)) meters"
        self.lblMaxElevation.text = maxLabel
        
        // Set Min Elevation
        let minLabel = eleMin == -1 ? "- meters" : "\(String(eleMin)) meters"
        self.lblMinElevation.text = minLabel
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
