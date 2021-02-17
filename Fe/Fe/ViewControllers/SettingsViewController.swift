//
//  SettingsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutButtonTapped))
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @objc func logOutButtonTapped() {
        // Set up log out action and check for errors
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive ) { action in
            do {
                try Auth.auth().signOut()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartScreen") as! StartViewController
                startViewController.modalPresentationStyle = .fullScreen
                self.present(startViewController, animated:true, completion:nil)
            } catch let err {
                print("Failed to sign out with error: ", err)
                let badSignOutAlert = UIAlertController(title: "Log Out Error", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                badSignOutAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(badSignOutAlert, animated: true, completion: nil)
            }
        }
        // Present the Alert with 2 actions
        let signOutAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        signOutAlert.addAction(logOutAction)
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(signOutAlert, animated: true, completion: nil)
    }
}
