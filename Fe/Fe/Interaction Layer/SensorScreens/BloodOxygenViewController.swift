//
//  BloodOxygenViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//
//  HeartRate Graph and data generation created by Kevin Grzela 2021-02-27

//MARK: Imports
import UIKit
import Charts

/*------------------------------------------------------------------------
 //MARK: BloodOxygenViewController : UIViewController
 - Description: Shows data for Blood Oxygen Sensor (past and current)
 -----------------------------------------------------------------------*/
class BloodOxygenViewController: UIViewController {
    
    // Class Variables
    let BldOxObj = BloodOxygenLogic()
    let CDLogic = CoreDataAccessObject()
    // UI Variables
    @IBOutlet var lblCurrentBldOx: UILabel!
    @IBOutlet var lblAvgBldOx: UILabel!
    @IBOutlet var lblMaxBldOx: UILabel!
    @IBOutlet var lblMinBldOx: UILabel!
    @IBOutlet var txtLowBldOxThreshold: UITextField!
    @IBOutlet var txtHighBldOxThreshold: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize variables and screen before it loads
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        txtLowBldOxThreshold.returnKeyType = .done
        txtLowBldOxThreshold.delegate = self
        txtHighBldOxThreshold.returnKeyType = .done
        txtHighBldOxThreshold.delegate = self
        setupTextFields()
        getUserBldOxThresholds()
        
//        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxValue in
//            self.lblCurrentBldOx.text = "\(String(bloodOxValue)) %"
//        })
        
        let bloodOxValue = BldOxObj.fetchLatestBloodOxReading()
        self.lblCurrentBldOx.text = "\(String(bloodOxValue)) %"
        
        initChart()
        
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
        
        self.txtLowBldOxThreshold.inputAccessoryView = toolbar
        self.txtHighBldOxThreshold.inputAccessoryView = toolbar
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
     //MARK: initChart()
     - Description: Code to inialize and load chart data
     -------------------------------------------------------------------*/
    
    func initChart() {
        
        var cdBldOxData = [BloodOxygenData]()
        var cdSPO2Data = [Double]()
        var cdDateData = [String]()
        cdBldOxData = CDLogic.fetchBloodOxygenData()!
        
        for item in cdBldOxData {
            let df = DateFormatter()
            cdDateData.append(df.string(from: item.dateTime))
            cdSPO2Data.append(Double(item.bloodOxygen))
        }
        
        let bldOxMin = Int(cdSPO2Data.min() ?? 0)
        let bldOxMax = Int(cdSPO2Data.max() ?? 0)
        var spo2sum = 0.0
        for item in cdSPO2Data {
            spo2sum+=item
        }
        if cdSPO2Data.count == 0 {
            self.lblAvgBldOx.text = "N/A"
        } else {
            let bldOxAvg = Int(spo2sum/Double(cdSPO2Data.count))
            self.lblAvgBldOx.text = "\(bldOxAvg) %"
        }//if
        
//        BldOxObj.fetchBloodOxWithRange(dateRange : "day", completion: { [self] dateArray, bldOxArray, bldOxMax, bldOxMin, bldOxAvg in
            
        lineChartView.data = BldOxObj.chartData(dataPoints: cdDateData, values: cdSPO2Data)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:cdDateData)
        lineChartView.xAxis.granularity = 0.05
            
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        //lineChartView.xAxis.labelRotationAngle = -30
        lineChartView.xAxis.setLabelCount(6, force: false)
        //lineChartView.backgroundColor = .systemRed
        
        //lineChartView.data?.setDrawValues(false)
        lineChartView.legend.enabled = false
        
        lineChartView.animate(xAxisDuration: 2)
        
        self.lblMaxBldOx.text = "\(bldOxMax) %"
        self.lblMinBldOx.text = "\(bldOxMin) %"
//        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: populateChart(dateRange: String)
     - Description: CURRENTLY UNUSED. Code to reload chart data
     -------------------------------------------------------------------*/
    
    func populateChart(dateRange: String) {
        BldOxObj.fetchBloodOxWithRange(dateRange : "day", completion: { [self] dateArray, bldOxArray, bldOxMax, bldOxMin, bldOxAvg in
            
            lineChartView.data = BldOxObj.chartData(dataPoints: dateArray, values: bldOxArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 0.05
            
            lineChartView.xAxis.labelPosition = .bottom
            lineChartView.xAxis.drawGridLinesEnabled = false
            //lineChartView.xAxis.labelRotationAngle = -30
            lineChartView.xAxis.setLabelCount(6, force: false)
            //lineChartView.backgroundColor = .systemRed
            
            self.lblAvgBldOx.text = "\(bldOxAvg) %"
            self.lblMaxBldOx.text = "\(bldOxMax) %"
            self.lblMinBldOx.text = "\(bldOxMin) %"
        })
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
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
        txtLowBldOxThreshold.inputAccessoryView = toolbar
        txtHighBldOxThreshold.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: dismisses keyboard.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: getUserBldOxThresholds()
     - Description: Fetches Blood Oxygen thresholds from Firebase.
     -------------------------------------------------------------------*/
    func getUserBldOxThresholds() {
        BldOxObj.getUserBldOxThresholds(completion: { thresholds in
            self.txtLowBldOxThreshold.text = thresholds["bldOxLowThreshold"]
            self.txtHighBldOxThreshold.text = thresholds["bldOxHighThreshold"]
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnUpdateBldOxThresholds()
     - Description: 
     -------------------------------------------------------------------*/
    @IBAction func btnUpdateBldOxThresholds(_ sender: Any) {
        if let bldOxLowThreshold = txtLowBldOxThreshold.text, bldOxLowThreshold.isEmpty  {
            let prompt = UIAlertController(title: "Missing Value", message: "Please enter a number for low threshold", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
            return
        }
        if let bldOxHighThreshold = txtHighBldOxThreshold.text, bldOxHighThreshold.isEmpty {
            let prompt = UIAlertController(title: "Missing Value", message: "Please enter a number for high threshold", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
            return
        }
        // SAVE TO FIREBASE
        BldOxObj.updateBldOxThresholds(lowThreshold: txtLowBldOxThreshold.text!, highThreshold: txtHighBldOxThreshold.text!, completion: { success in
            let prompt = UIAlertController(title: "Threshold Update Successful", message: "Your Blood Oxygen thresholds have been suuccessfully updated.", preferredStyle: .alert)
            if !success {
                prompt.title = "Threshold Update Not Successful"
                prompt.message = "Your Blood Oxygen thresholds have not been updated."
            }
            let confirm = UIAlertAction(title: "OK", style: .default)
            prompt.addAction(confirm)
            self.present(prompt, animated: true, completion: nil)
        })
    }
}

/*------------------------------------------------------------------------
 //MARK: BloodOxygenViewController : UITextFieldDelegate
 - Description: Logic for removing keyboard from screen.
 -----------------------------------------------------------------------*/
extension BloodOxygenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
