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
        // Pull phone number from FireStore
        FirebaseAccessObject().fetchDoctorPhoneNumber(completion: { phone in
            if let url = NSURL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        })
    }
    
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
