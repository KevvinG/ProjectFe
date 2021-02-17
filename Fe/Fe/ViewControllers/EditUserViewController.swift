//
//  EditUserViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-17.
//

import UIKit
import Firebase

class EditUserViewController: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func saveChangesBtnTapped(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
        }
        var ref : DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "UID" : user?.uid,
            "fname" : "Ada",
            "lname" : "Wong",
        ]) { err in
            if let err = err {
                print("Error adding Document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
