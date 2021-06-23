//
//  Symptom3BloodStoolViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: Symptom3BloodStoolViewController : UIViewController
 - Description: Holds logic for the 3rd question view controller.
 -----------------------------------------------------------------------*/
class Symptom3BloodStoolViewController: UIViewController {

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     //MARK: yesBtnTapped()
     - Description: Move to call Doctor Screen.
     -------------------------------------------------------------------*/
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom3ToDoctorScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: noBtnTapped()
     - Description: Move to question 3 view controller.
     -------------------------------------------------------------------*/
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBlack", sender: self)
    }
}
