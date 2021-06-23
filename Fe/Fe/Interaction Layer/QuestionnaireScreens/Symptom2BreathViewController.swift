//
//  Symptom2BreathViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: Symptoom2BreathViewController : UIViewController
 - Description: Holds logic for the 2nd question view controller.
 -----------------------------------------------------------------------*/
class Symptom2BreathViewController: UIViewController {

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
        performSegue(withIdentifier: "Symptom2ToDoctorScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: noBtnTapped()
     - Description: Move to question 3 view controller.
     -------------------------------------------------------------------*/
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBlood", sender: self)
    }
}
