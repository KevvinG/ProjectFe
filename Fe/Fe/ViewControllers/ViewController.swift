//
//  ViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-10.
//

// Imports
import UIKit
import FirebaseUI
import GoogleSignIn

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
            NSLog("There was an error with setting authUI")
            return
        }
        authUI?.delegate = self
        
        let providers : [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth()
        ]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     - Function: application()
     - Description: Handler for result of Google Sign Up.
     -------------------------------------------------------------------*/
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
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
