//
//  Symptom4BlackStoolViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

import UIKit

class Symptom4BlackStoolViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom4ToDoctorScreen", sender: self)
    }
    
    @IBAction func noBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Symptom4ToAOK", sender: self)
    }
}
