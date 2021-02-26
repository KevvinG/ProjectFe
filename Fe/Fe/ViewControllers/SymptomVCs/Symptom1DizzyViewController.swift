//
//  Symptom1-DizzyViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

import UIKit

class Symptom1DizzyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom1ToDoctorScreen", sender: self)
    }

    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomBreath", sender: self)
    }
}
