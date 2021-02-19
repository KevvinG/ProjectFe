//
//  SettingsViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    let db = Firestore.firestore()

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
    
    
    
    @IBAction func editAccountBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEditUser", sender: self)
    }
    
    
    @IBAction func deleteAccountBtnTapped(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive ) { action in
            do {
                let user = Auth.auth().currentUser
                user?.delete { error in
                    if let error = error {
                        print("There was an error getting the user: \(error)")
                    } else {
                        // Search for document ID and Delete it.
                        let usersRef = self.db.collection("users")
                        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
                            .getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if querySnapshot!.documents.count == 0 {
                                        print("The user cannot be found")
                                    } else {
                                        print("We found the user.")
                                        for document in querySnapshot!.documents {
                                            print(document)
                                            // DELETE THE USER DOCUMENT
                                            self.db.collection("users").document(document.documentID).delete() { err in
                                                if let err = err {
                                                    print("Error removing the document: \(err)")
                                                } else {
                                                    print("Document successfully deleted.")
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        
                        // Sign the User Out
                        do {
                            try Auth.auth().signOut()
                        } catch let err {
                            print("Failed to sign out with error: \(err)")
                        }
                        
                        // Redirect the user to the StartViewController
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartScreen") as! StartViewController
                        startViewController.modalPresentationStyle = .fullScreen
                        self.present(startViewController, animated:true, completion:nil)
                    }
                }
            }
        }
        // Prompt before deleting
        let msg = "Are you sure you Want to delete your account?"
        let deleteAccountAlert = UIAlertController(title: "Delete Account", message: msg, preferredStyle: UIAlertController.Style.alert)
            deleteAccountAlert.addAction(deleteAction)
            deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAccountAlert, animated: true, completion: nil)
    }
}
