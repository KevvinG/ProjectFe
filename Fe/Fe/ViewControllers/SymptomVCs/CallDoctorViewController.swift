//
//  CallDoctorViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

import UIKit

class CallDoctorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func callDoctorBtnTapped(_ sender: UIButton) {
        // Logic to open phone app, grab doctor number, get ready to call.
    }
    
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
