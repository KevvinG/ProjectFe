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
    
    // UI Interactions
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtStAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    
    // Class Variables
    let db = Firestore.firestore()
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
    }
    
    /*--------------------------------------------------------------------
     - Function: saveChangeBtnTapped()
     - Description: Finds the user information in Firestore then updates.
     -------------------------------------------------------------------*/
    @IBAction func saveChangesBtnTapped(_ sender: UIButton) {
        let txt_email = txtEmail.text
        let first_name = fName.text
        let last_name = lName.text
        let txt_password = txtPassword.text
        let txt_st_address = txtStAddress.text
        let txt_city = txtCity.text
        let txt_postal = txtPostal.text
        
        let confirmationMessage = UIAlertController(title: "Data Confirmation", message: "New information:\nFirst name: \(first_name ?? "First Name")\nLast name: \(last_name ?? "Last Name")\nEmail: \(txt_email ?? "Email")", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            // print("Ok button tapped")
            self.updateUserData(first_name:first_name!, last_name:last_name!, txt_email:txt_email!, txt_st_address: txt_st_address!, txt_postal: txt_postal!, txt_city: txt_city!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            // print("Ok button tapped")
        })
        
        confirmationMessage.addAction(confirm)
        confirmationMessage.addAction(cancel)
        
        self.present(confirmationMessage, animated: true, completion: nil)
    }
    
    func getUserData() {
        let usersRef = db.collection("users")
        let user = Auth.auth().currentUser
        
        var lblPostal = ""
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
                        for document in querySnapshot!.documents {
                            print("getUserData \n")
                            print("\(document.documentID) => \(document.data())")
                            let ref = document.reference
                            lblPostal = document.data()["postal"] as! String
                            self.txtPostal.text = lblPostal
                            self.fName.text = document.data()["fName"] as? String
                            self.lName.text = document.data()["lName"] as? String
                            self.txtEmail.text = document.data()["email"] as? String
                            self.txtStAddress.text = document.data()["street1"] as? String
                            self.txtCity.text = document.data()["city"] as? String

                        }
                    }
                }
        }
        
    }
    
    /*--------------------------------------------------------------------
     - Function:updateUserData()
     - Description: Gets user from Firestore using email and updates data.
     -------------------------------------------------------------------*/
    func updateUserData(first_name: String, last_name: String, txt_email: String, txt_st_address: String, txt_postal: String, txt_city: String) {
        print("Updating existing user...")
        let usersRef = db.collection("users")
        let user = Auth.auth().currentUser

        
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
                            let ref = document.reference
                            // TODO: Update the user details here
                            
                            Auth.auth().currentUser?.updateEmail(to: txt_email) { (error) in
                                
                            }
                            
                            ref.updateData([
                                "fName": first_name,
                                "lName": last_name,
                                "email": txt_email,
                                "street1": txt_st_address,
                                "postal": txt_postal,
                                "city": txt_city
                            ]);
                        }
                    }
                }
        }
    }
    
}
