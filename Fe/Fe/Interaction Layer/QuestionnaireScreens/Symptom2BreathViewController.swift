//
//  Symptom2BreathViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: Symptoom2BreathViewController : UIViewController
 - Description: Holds logic for the 2nd question view controller.
 -----------------------------------------------------------------------*/
class Symptom2BreathViewController: UIViewController {

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     - Function: yesBtnTapped()
     - Description: Move to call Doctor Screen.
     -------------------------------------------------------------------*/
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom2ToDoctorScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: noBtnTapped()
     - Description: Move to question 3 view controller.
     -------------------------------------------------------------------*/
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBlood", sender: self)
    }
}
