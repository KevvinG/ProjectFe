//
//  HomeViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-13.
//

// Imports
import UIKit
import Firebase

/*------------------------------------------------------------------------
 - Extension: HomeViewController : UIViewController
 - Description: Holds logic for the the User Home Screen
 -----------------------------------------------------------------------*/
class HomeViewController: UIViewController {
    
    // Class Variables
    let db = Firestore.firestore()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIfNewUser() // Add User to Firebase Table if New
    }
    
    /*--------------------------------------------------------------------
     - Function: prepare()
     - Description: Prepare any code before changing scenes.
     -------------------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
    }

    /*--------------------------------------------------------------------
     - Function: checkIfNewUser()
     - Description: Checks if email is already in Firestore
     -------------------------------------------------------------------*/
    func checkIfNewUser() {
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("Adding new user.")
                        self.addNewUser()
                    } else {
                        print("This user already exists.")
                    }
                }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: addNewUser()
     - Description: logic to add user to Firebase Firestore
     -------------------------------------------------------------------*/
    func addNewUser() {
        let user = Auth.auth().currentUser
        // TODO: - Change this to use the struct model User
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "uid": user!.uid,
            "email": user!.email!,
            "fName": "",
            "lName": "",
            "street1": "",
            "street2": "",
            "city": "",
            "postal": "",
            "province": "",
            "country": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
