//
//  HomeVC.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-13.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: HomeVC : UIViewController
 - Description: Holds UI Interactions for the Home Screen
 -----------------------------------------------------------------------*/
class HomeVC: UIViewController {
    
    // Class Variables
    let HSLogic = HomeScreenLogic()
    let FBObj = FirebaseAccessObject()
    let HRObj = HeartRateLogic()
    let BldOxObj = BloodOxygenLogic()
    let AltObj = AltitudeLogic()
    let DAObj = DataAnalysisLogic()
    
    // UI Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblHeartRateValue: UILabel!
    @IBOutlet var lblBloodOxygenValue: UILabel!
    @IBOutlet var lblAltitudeValue: UILabel!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
//        HSLogic.homeScreenSetup() // Setup options once logged in.
        
        // Check if user already exists and add new user if not.
        FBObj.checkIfNewUser()
        
        // Set Name at top of UI
        FBObj.getUserName(completion: { name in
            self.setWelcomeTitle(title: "Welcome back, \(name)!")
        })
        
        // Set off each method at start to fill UI
        altTimerFire()
        hrTimerfire()
        bloodOxTimerfire()
        
        // Timer
        let timer = CustomTimer { (seconds) in
            
            if seconds % 300 == 0 { // Fire every 5 minutes (300 seconds)
                if let hrSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationHRKey.description), hrSwitchState {
                    self.DAObj.analyzeHeartRateData()
                }
                
                if let bloodOxSwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotificationBOKey.description), bloodOxSwitchState {
                    self.DAObj.analyzeBloodOxygenData()
                }
            }
            
            if seconds % 60 == 0 { // Fire every 60 seconds
                self.altTimerFire()
            }
            
            if seconds % 5 == 0 { // Fire every 5 seconds - Watch sends messages in this interval
                self.hrTimerfire()
                self.bloodOxTimerfire()
            }
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
            self.lblBloodOxygenValue.text = "\(bloodOxygen) %"
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
            self.lblAltitudeValue.text = "\(pressure) hPa"
            print("Air Pressure Timer Val: \(pressure)")
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: setWelcomeTitle()
     - Description: Set UI Welcome Title
     -------------------------------------------------------------------*/
    func setWelcomeTitle(title: String) {
        self.lblTitle.text = title
    }
    
    /*--------------------------------------------------------------------
     //MARK: setHRButtonValue()
     - Description: Set HR Button Value
     -------------------------------------------------------------------*/
    func setHRButtonValue(labelValue: String) {
        self.lblHeartRateValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: setBloodOxButtonValue()
     - Description: Set Blood Oxygen Button Value
     -------------------------------------------------------------------*/
    func setBloodOxButtonValue(labelValue: String) {
        self.lblBloodOxygenValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: setAltitudeButtonValue()
     - Description: Set Altitude Button Value
     -------------------------------------------------------------------*/
    func setAltitudeButtonValue(labelValue: String) {
        self.lblAltitudeValue.text = labelValue
    }
    
    /*--------------------------------------------------------------------
     //MARK: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func btnHeartRateTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToHeartRateScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnBloodOxygenTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func btnBloodOxygenTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToBloodOxygenScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnAltitudeTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func btnAltitudeTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToAltitudeScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func btnSymptomsTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: btnMoreInfoTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func btnMoreInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
