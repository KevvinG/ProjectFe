//
//  Symptom4BlackStoolViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: Symptom4BlackStoolViewController : UIViewController
 - Description: Holds logic for the 4th question view controller.
 -----------------------------------------------------------------------*/
class Symptom4BlackStoolViewController: UIViewController {

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     //MARK: yesBtnTapped()
     - Description: Move to call Doctor Screen.
     -------------------------------------------------------------------*/
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom4ToDoctorScreen", sender: self)
    }
    
    /*--------------------------------------------------------------------
     //MARK: noBtnTapped()
     - Description: Move to AOK view controller.
     -------------------------------------------------------------------*/
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom4ToAOK", sender: self)
    }
}
