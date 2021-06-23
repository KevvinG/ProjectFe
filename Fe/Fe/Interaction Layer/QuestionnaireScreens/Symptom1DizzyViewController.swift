//
//  Symptom1-DizzyViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: Symptom1DizzyViewController : UIViewController
 - Description: Holds logic for the 1st question view controller.
 -----------------------------------------------------------------------*/
class Symptom1DizzyViewController: UIViewController {
    
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
        performSegue(withIdentifier: "Symptom1ToDoctorScreen", sender: self)
    }

    /*--------------------------------------------------------------------
     //MARK: noBtnTapped()
     - Description: Move to question 2 view controller.
     -------------------------------------------------------------------*/
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBreath", sender: self)
    }
}
