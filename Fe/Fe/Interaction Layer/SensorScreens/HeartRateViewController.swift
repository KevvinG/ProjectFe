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
        txtLowHrThreshold.returnKeyType = .done
        txtLowHrThreshold.delegate = self
        txtHighHrThreshold.returnKeyType = .done
        txtHighHrThreshold.delegate = self
        setupTextFields()
        getUserHrThresholds()
        
        self.lblCurrentHR.text = "\(String(HRLogic.fetchLatestHrReading())) BPM"
        
        initChart()

//        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMin, bpmAvg in
//
//            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
//            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
//            lineChartView.xAxis.granularity = 0.05
//            lineChartView.xAxis.labelPosition = .bottom
//            lineChartView.xAxis.drawGridLinesEnabled = false
//            lineChartView.xAxis.labelRotationAngle = -30
//            lineChartView.xAxis.labelCount = 4
//
//            self.lblAvgHR.text = "\(bpmAvg) BPM"
//            self.lblMaxHR.text = "\(bpmMax) BPM"
//            self.lblMinHR.text = "\(bpmMin) BPM"
       // })
    }
    
    func initChart() {
        HRLogic.fetchHrWithRange(dateRange : "day", completion: { [self] dateArray, bpmArray, bpmMax, bpmMin, bpmAvg in
            
            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 0.05
            
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.xAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.labelRotationAngle = -30
            lineChartView.xAxis.setLabelCount(6, force: false)
            //lineChartView.backgroundColor = .systemRed
            
            //lineChartView.data?.setDrawValues(false)
            lineChartView.legend.enabled = false
            
            lineChartView.animate(xAxisDuration: 2)
            
            self.lblAvgHR.text = "\(bpmAvg) BPM"
            self.lblMaxHR.text = "\(bpmMax) BPM"
            self.lblMinHR.text = "\(bpmMin) BPM"
        })
    }
    
    func populateChart(dateRange: String) {
        HRLogic.fetchHrWithRange(dateRange : dateRange, completion: { [self] dateArray, bpmArray, bpmMax, bpmMin, bpmAvg in
            
            lineChartView.data = HRLogic.chartData(dataPoints: dateArray, values: bpmArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 0.05
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.xAxis.drawGridLinesEnabled = false
            //lineChartView.xAxis.labelRotationAngle = -30
            lineChartView.xAxis.labelCount = 4
            lineChartView.backgroundColor = .systemRed
            
            self.lblAvgHR.text = "\(bpmAvg) BPM"
            self.lblMaxHR.text = "\(bpmMax) BPM"
            self.lblMinHR.text = "\(bpmMin) BPM"
        })
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        //print(entry)
    }
    
    
    
    /*--------------------------------------------------------------------
     //MARK: setupTextFields()
     - Description: Add toolbar to number pad keyboards.
     -------------------------------------------------------------------*/
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        txtLowHrThreshold.inputAccessoryView = toolbar
        txtHighHrThreshold.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: dismisses keyboard.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
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
            let prompt = UIAlertController(title: "Missing Value", message: "Please enter a number for low threshold", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
            return
        }
        if let hrHighThreshold = txtHighHrThreshold.text, hrHighThreshold.isEmpty {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
