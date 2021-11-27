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
public class AOKViewController: UIViewController {
    
    // Class Variables
    let QuestLogic = Questionnaire()

    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*--------------------------------------------------------------------
     //MARK: callDoctorBtnTapped()
     - Description: fetches doctor phone number and opens call ability.
     -------------------------------------------------------------------*/
    @IBAction func callDoctorBtnTapped(_ sender: UIButton) {
        QuestLogic.callDoctor(completion: { (doctorPhone) -> Void in
            if let url = NSURL(string: "tel://\(doctorPhone)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            } else {
                let msg = "Go to Settings and add a phone number for your doctor to use this feature."
                let updateAlert = UIAlertController(title: "No doctor phone number found", message: msg, preferredStyle: UIAlertController.Style.alert)
                updateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(updateAlert, animated: true, completion: nil)
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
