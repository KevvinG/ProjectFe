//
//  HomeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

//MARK: Imports
import UIKit
import CoreData

/*------------------------------------------------------------------------
 //MARK: HomeViewController : UIViewController
 - Description: Holds logic for the the User Home Screen
 -----------------------------------------------------------------------*/
class HomeViewController: UIViewController {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    let HRObj = HeartRateLogic()
    let BldOxObj = BloodOxygenLogic()
    let AltObj = AltitudeLogic()
    let HSLogic = HomeScreenLogic()
    let DALogic = DataAnalysisLogic()
    var counter = 0
    
    // UI Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnHeartRate: UIButton!
    @IBOutlet var lblHeartRateValue: UILabel!
    @IBOutlet var btnBloodOx: UIButton!
    @IBOutlet var lblBloodOx: UILabel!
    @IBOutlet var btnAltitude: UIButton!
    @IBOutlet var lblAltitude: UILabel!
    @IBOutlet var btnCheckSymptoms: UIButton!
    @IBOutlet var btnMoreInfo: UIButton!
    

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Name at top of UI
        FBObj.getUserName(completion: { name in
            self.lblTitle.text = "Welcome back, \(name)!"
        })
        FBObj.checkIfNewUser() // Check if user already exists and add new user if not.
        
        // Set off each method at start to fill UI
        altTimerFire()
        hrTimerfire()
        bloodOxTimerfire()
        
        // Timer
        let timer = CustomTimer { (seconds) in
            if seconds % 300 == 0 {
                self.DALogic.analyzeHeartRateData() // Fire every 5 minutes
                self.DALogic.analyzeBloodOxygenData() // Fire every 5 minutes
            }
            if seconds % 15 == 0 {
                self.altTimerFire() // Fire every 15 seconds
            }
            self.hrTimerfire() // Fire every 1 second
            self.bloodOxTimerfire() // Fire every 1 second
        }
        timer.start()
    }

    /*--------------------------------------------------------------------
     //MARK: HRTimerfire()
     - Description: Method to update Heart Rate.
     -------------------------------------------------------------------*/
    @objc func hrTimerfire()
    {
        let hrVal = HRObj.fetchLatestHrReading()
        self.lblHeartRateValue.text = "\(hrVal) BPM"
        print("HR Timer Val: \(hrVal)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: BloodOxTimerfire()
     - Description: Method to update Blood Oxygen.
     -------------------------------------------------------------------*/
    @objc func bloodOxTimerfire()
    {
        BldOxObj.fetchLatestBloodOxReading(completion: { bloodOxygen in
            self.lblBloodOx.text = "\(bloodOxygen) %"
            print("Blood Ox Timer Val: \(bloodOxygen)")
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: AltTimerFire()
     - Description:  method to update Air Pressure.
     -------------------------------------------------------------------*/
    @objc func altTimerFire()
    {
        AltObj.fetchPressureReading(completion: { pressure in
            self.lblAltitude.text = "\(pressure) hPa"
            print("Air Pressure Timer Val: \(pressure)")
        })
    }

    /*--------------------------------------------------------------------
     //MARK: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func heartRateBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToHeartRateScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: bloodOxygenBtnTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func bloodOxygenBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToBloodOxygenScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: altitudeBtnTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func altitudeBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAltitudeScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: viewDocumentsBtnTapped()
     - Description: Segue to viewDocuments table View
     -------------------------------------------------------------------*/
    @IBAction func viewDocumentsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToDocumentsScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: uploadDocumentBtnTapped()
     - Description: Segue to upload document view
     -------------------------------------------------------------------*/
    @IBAction func uploadDocumentBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToUploadDocumentScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func checkSymptomsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: moreInformationBtnTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func moreInformationBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
