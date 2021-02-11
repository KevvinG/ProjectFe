//
//  ViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-10.
//

// Imports
import UIKit
import FirebaseUI

/*--------------------------------------------------------------------
 - Class: ViewController : UIViewController
 - Description: ViewController logic file for the Start Screen.
 -------------------------------------------------------------------*/
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*--------------------------------------------------------------------
     - Function: loginTapped()
     - Description: Shows the different FirebaseUI ways to sign in.
     -------------------------------------------------------------------*/
    @IBAction func loginTapped(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // Log error
            return
        }
        authUI?.delegate = self
        
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
    }
}

/*--------------------------------------------------------------------
 - Extension: ViewController : FUIAuthDelegate
 - Description: If no errors detected, proceed to the Home Screen.
 -------------------------------------------------------------------*/
extension ViewController : FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            // log error
            return
        }
        performSegue(withIdentifier: "GoToHomeScreen", sender: self)
    }
}
