//
//  AOKViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

import UIKit

class AOKViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func callDoctorBtnTapped(_ sender: UIButton) {
        // Logic to open phone app and call doctor
    }
    
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
