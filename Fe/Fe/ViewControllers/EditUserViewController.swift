//
//  EditUserViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-17.
//

// Imports
import UIKit
import Firebase

/*------------------------------------------------------------------------
 - Extension: EditUserViewController : UIViewController
 - Description: Holds logic for the User Account Settings Screen
 -----------------------------------------------------------------------*/
class EditUserViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    // Class Variables
    let db = Firestore.firestore()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*--------------------------------------------------------------------
     - Function: saveChangeBtnTapped()
     - Description: Finds the user information in Firestore then updates.
     -------------------------------------------------------------------*/
    @IBAction func saveChangesBtnTapped(_ sender: UIButton) {
        print("Updating existing user...")
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        let txt_email = txtEmail.text
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("There was a database error.  the user wasn't created in the Firebase DB in HomeViewController.")
                        let alert = UIAlertController(title: "ERROR", message: "Unable to fetch your user information form the table", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Code here to update user in table")
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            // TODO: Update the user details here
                            Auth.auth().currentUser?.updateEmail(to: txt_email!) { (error) in
                                
                            }
                        }
                    }
                }
        }
    }
    
}
