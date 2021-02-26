//
//  Symptom2BreathViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

import UIKit

class Symptom2BreathViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom2ToDoctorScreen", sender: self)
    }
    
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBlood", sender: self)
    }
}
