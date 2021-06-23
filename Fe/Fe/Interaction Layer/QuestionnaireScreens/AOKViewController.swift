//
//  AOKViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: AOKViewController : UIViewController
 - Description: Holds logic for the Everything OK view controller.
 -----------------------------------------------------------------------*/
class AOKViewController: UIViewController {

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     //MARK: callDoctorBtnTapped()
     - Description: fetches doctor phone number and opens call ability.
     -------------------------------------------------------------------*/
    @IBAction func callDoctorBtnTapped(_ sender: UIButton) {
        Questionnaire().callDoctor(completion: { (doctorPhone) -> Void in
            if let url = NSURL(string: "tel://\(doctorPhone)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: returnBtnTapped()
     - Description: Pop back to home screen.
     -------------------------------------------------------------------*/
    @IBAction func returnBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
