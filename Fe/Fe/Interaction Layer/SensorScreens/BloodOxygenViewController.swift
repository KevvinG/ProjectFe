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
        txtLowBldOxThreshold.returnKeyType = .done
        txtLowBldOxThreshold.delegate = self
        txtHighBldOxThreshold.returnKeyType = .done
        txtHighBldOxThreshold.delegate = self
        setupTextFields()
        getUserBldOxThresholds()
        
        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxValue in
            self.lblCurrentBldOx.text = "Current Blood Oxygen: \(String(bloodOxValue)) %"
        })
        
        BldOxObj.fetchBloodOxWithRange(dateRange : "day", completion: { [self] dateArray, bldOxArray, bldOxMax, bldOxMin in
            lineChartView.data = BldOxObj.chartData(dataPoints: dateArray, values: bldOxArray)
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateArray)
            lineChartView.xAxis.granularity = 1
            self.lblMaxBldOx.text = "\(Int(bldOxArray.max() ?? 0)) %"
            self.lblMinBldOx.text = "\(Int(bldOxArray.min() ?? 0)) %"
        })
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
