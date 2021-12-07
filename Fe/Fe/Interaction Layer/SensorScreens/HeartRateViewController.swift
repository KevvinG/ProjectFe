//
//  HeartRateViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-26

//MARK: Imports
import UIKit
import Charts

/*------------------------------------------------------------------------
 //MARK: HeartRateViewController : UIViewController
 - Description: Holds logic for the Heart Rate Screen
 -----------------------------------------------------------------------*/
class HeartRateViewController: UIViewController, ChartViewDelegate {
    
    // Class Variables
    let HRLogic = HeartRateLogic()
    let CDLogic = CoreDataAccessObject()

    // UI Variables
    @IBOutlet var lblCurrentHR: UILabel!
    @IBOutlet var lblAvgHR: UILabel!
    @IBOutlet var lblMaxHR: UILabel!
    @IBOutlet var lblMinHR: UILabel!
    @IBOutlet var txtLowHrThreshold: UITextField!
    @IBOutlet var txtHighHrThreshold: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        txtLowHrThreshold.returnKeyType = .done
        txtLowHrThreshold.delegate = self
        txtHighHrThreshold.returnKeyType = .done
        txtHighHrThreshold.delegate = self
        
        setupTextFields()
        getUserHrThresholds()
        asyncChartInitHelper()
        
        //Setup tap handling on chart
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapChart))
        self.lineChartView.addGestureRecognizer(gesture)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupTextFields()
     - Description: Set up keyboard for text field.
     -------------------------------------------------------------------*/
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.txtLowHrThreshold.inputAccessoryView = toolbar
        self.txtHighHrThreshold.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: Selector for finishing keyboard editiing.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: tapChart(sender: UITapGestureRecognizer)
     - Description: Handles tapping on chart
     -------------------------------------------------------------------*/
    @objc func tapChart(sender : UITapGestureRecognizer) {
        print("tapped")
    }
    
    /*--------------------------------------------------------------------
     //MARK: asyncChartInitHelper()
     - Description: Asynchronous chart helper
     -------------------------------------------------------------------*/
    
    func asyncChartInitHelper() {
        var cdHRData = [HeartRateData]()

        DispatchQueue.global(qos: .background).async {
            cdHRData = self.CDLogic.fetchHeartRateDataWithRange(dateRange: "day")!
            DispatchQueue.main.async {
                self.initChart(hrData: cdHRData)
            }
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: initChart()
     - Description: Initializes chart with data
     -------------------------------------------------------------------*/
    func initChart(hrData: [HeartRateData]) {
        
        let cdHRData = hrData
        var cdBPMData = [Double]()
        var cdDateData = [String]()
        

        
        for item in cdHRData {
            let df = DateFormatter()
            df.dateFormat = "hh:mm"
            cdDateData.append(df.string(from: item.dateTime))
            print(df.string(from: item.dateTime))
            cdBPMData.append(Double(item.heartRate))
        }
        //if
            
        lineChartView.data = HRLogic.chartData(dataPoints: cdDateData, values: cdBPMData)
        
        let customFormatter = CustomFormatter()
        customFormatter.labels = cdDateData
        lineChartView.xAxis.valueFormatter = customFormatter
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.animate(xAxisDuration: 2)
        
        // Set Current HR Value
        let hrVal = HRLogic.fetchLatestHrReading()
        let currLabel = hrVal == -1 ? "- BPM" : "\(String(hrVal)) BPM"
        self.lblCurrentHR.text = currLabel
        
        // Get Stats
        let bpmMin = Int(cdBPMData.min() ?? -1)
        let bpmMax = Int(cdBPMData.max() ?? -1)
        var bpmSum = 0.0
        for item in cdBPMData {
            bpmSum+=item
        }
        
        // Set Average BPM
        let avgLabel = cdBPMData.count == 0 ? "- BPM" : "\(String(Int(bpmSum/Double(cdBPMData.count)))) BPM"
        self.lblAvgHR.text = avgLabel
        
        // Set Max BPM
        let maxLabel = bpmMax == -1 ? "- BPM" : "\(String(bpmMax)) BPM"
        self.lblMaxHR.text = maxLabel
        
        // Set Min BPM
        let minLabel = bpmMin == -1 ? "- BPM" : "\(String(bpmMin)) BPM"
        self.lblMinHR.text = minLabel
//        })
    }
    
    
    /*--------------------------------------------------------------------
     //MARK: populateChart(dateRange: String)
     - Description: CURRENTLY UNUSED. Code to reload chart data
     -------------------------------------------------------------------*/
    func populateChart(dateRange: String) {
        HRLogic.fetchHrWithRange(dateRange : dateRange, completion: { [self] dateArray, bpmArray, bpmMax, bpmMin, bpmAvg in
            
            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 0.05
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.xAxis.drawGridLinesEnabled = false
            //lineChartView.xAxis.labelRotationAngle = -30
            lineChartView.xAxis.labelCount = 4
            //lineChartView.backgroundColor = .systemRed
            
            self.lblAvgHR.text = "\(bpmAvg) BPM"
            self.lblMaxHR.text = "\(bpmMax) BPM"
            self.lblMinHR.text = "\(bpmMin) BPM"
        })
        //CDLogic.fetchHeartRateData()
    }
    
    /*--------------------------------------------------------------------
     //MARK: chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
     - Description: Handles selecting a single value on chart. Currently unused
     -------------------------------------------------------------------*/
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    /*--------------------------------------------------------------------
     //MARK: getUserHrThresholds()
     - Description: Fetches HR thresholds from Firebase
     -------------------------------------------------------------------*/
    func getUserHrThresholds() {
        HRLogic.getUserHrThresholds(completion: { thresholds in
            self.txtLowHrThreshold.text = thresholds["hrLowThreshold"]
            self.txtHighHrThreshold.text = thresholds["hrHighThreshold"]
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnUpdateHrThreshold()
     - Description: Updates Firebase Threshold values for user.
     -------------------------------------------------------------------*/
    @IBAction func btnUpdateHrThresholds(_ sender: Any) {
        if let hrLowThreshold = txtLowHrThreshold.text, hrLowThreshold.isEmpty  {
            UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdLowKey.description, value: hrLowThreshold)
            let prompt = UIAlertController(title: "Missing Value", message: "Please enter a number for low threshold", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
            return
        }
        if let hrHighThreshold = txtHighHrThreshold.text, hrHighThreshold.isEmpty {
            UserDefaults.standard.setValue(key: UserDefaultKeys.hrThresholdHighKey.description, value: hrHighThreshold)
            let prompt = UIAlertController(title: "Missing Value", message: "Please enter a number for high threshold", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
            return
        }
        
        // SAVE TO FIREBASE
        HRLogic.updateHrThresholds(lowThreshold: txtLowHrThreshold.text!, highThreshold: txtHighHrThreshold.text!, completion: { success in
            let prompt = UIAlertController(title: "Threshold Update Successful", message: "Your Heart Rate thresholds have been suuccessfully updated.", preferredStyle: .alert)
            if !success {
                prompt.title = "Threshold Update Not Successful"
                prompt.message = "Your Heart Rate thresholds have not been updated."
            }
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
        })
    }
}

/*------------------------------------------------------------------------
 //MARK: HeartRateViewController : UITextFieldDelegate
 - Description: Logic for removing keyboard from screen.
 -----------------------------------------------------------------------*/
extension HeartRateViewController: UITextFieldDelegate {
    
    /*--------------------------------------------------------------------
     //MARK: textFieldShouldReturn()
     - Description: Close Keyboard.
     -------------------------------------------------------------------*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
