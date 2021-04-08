//
//  HomeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

// Imports
import UIKit
import CorePlot


/*------------------------------------------------------------------------
 - Class: HomeViewController : UIViewController
 - Description: Holds logic for the the User Home Screen
 -----------------------------------------------------------------------*/
class HomeViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var txtWelcomeMsg: UILabel!
    @IBOutlet var txtTestMsg: UILabel!
    @IBOutlet var hrButton: UIButton!
    
    let HKObj = HKAccessObject()
  var counter = 0
    // Set up button on screen. To be removed.
//    private let hrbutton : SensorCustomButton = {
//        let button = SensorCustomButton(frame: CGRect(x:0, y:0, width:150, height:150))
//        button.addTarget(self, action: #selector(heartRateBtnTapped), for: .touchUpInside)
//        return button
//    }()
//
//    @objc func heartRateBtnTapped(sender: UIButton!) {
//        print("Tapped")
//    }
    

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        let objFB = FirebaseAccessObject()
        objFB.checkIfNewUser() // Check if user already exists and add new user if not.
        
        // Set Name at top of UI
        FirebaseAccessObject().getUserName(completion: { name in
            self.txtWelcomeMsg.text = "Welcome back, \(name)!"
        })
        
        // Create Custom button
//        let vmHrBtn = SensorCustomButton(mainTitle: "Heart Rate", currentSubtitle: "Current: 75 BPM", averageSubtitle: "Average: 82 BPM", imageName: "heart")
//        view.addSubview(hrbutton)
//        hrbutton.center = view.center
    }


    @objc func fire()
    {
        self.HKObj.getLatestHR{ (test) in
            self.hrButton.setTitle(String(test), for: .normal)
            print(Int(test))
        }
    }
    /*--------------------------------------------------------------------
     - Function: prepare()
     - Description: Prepare any code before changing scenes.
     -------------------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
    }
    
    /*--------------------------------------------------------------------
     - Function: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func heartRateBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToHeartRateScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: bloodOxygenBtnTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func bloodOxygenBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToBloodOxygenScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: altitudeBtnTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func altitudeBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAltitudeScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: viewDocumentsBtnTapped()
     - Description: Segue to viewDocuments table View
     -------------------------------------------------------------------*/
    @IBAction func viewDocumentsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToDocumentsScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadDocumentBtnTapped()
     - Description: Segue to upload document view
     -------------------------------------------------------------------*/
    @IBAction func uploadDocumentBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToUploadDocumentScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func checkSymptomsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: moreInformationBtnTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func moreInformationBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
