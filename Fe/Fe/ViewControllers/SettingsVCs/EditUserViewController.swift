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
 - Class: EditUserViewController : UIViewController
 - Description: Holds logic for the User Account Settings Screen
 -----------------------------------------------------------------------*/
class EditUserViewController: UIViewController {
    
    // Class Variables
    let db = Firestore.firestore()
    
    // UI Variables
    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var txtlName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtStAddress1: UITextField!
    @IBOutlet weak var txtStAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    let provinces = [
        "BC", "AB", "MB", "NB", "NL",
        "NS", "NT", "NU", "ON", "PE",
        "QC", "SK", "YT"
    ]
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    /*--------------------------------------------------------------------
     - Function: saveChangeBtnTapped()
     - Description: Finds the user information in Firestore then updates.
     -------------------------------------------------------------------*/
    @IBAction func saveChangesBtnTapped(_ sender: UIButton) {
        
        let txt_fname = txtfName.text
        let txt_lname = txtlName.text
        let txt_email = txtEmail.text
        let txt_phone = txtphoneNo.text
        let txt_st_address1 = txtStAddress1.text
        let txt_st_address2 = txtStAddress2.text
        let txt_city = txtCity.text
        let txt_province = txtProvince.text
        let txt_postal = txtPostal.text
        let txt_country = txtCountry.text
        
        let confirmationMessage = UIAlertController(title: "Data Confirmation", message: "New information:\nFirst Name: \(txt_fname ?? "First Name")\nLast Name: \(txt_lname ?? "Last Name")\nEmail: \(txt_email ?? "Email")\nPhone: \(txt_phone ?? "Phone")\nStreet 1: \(txt_st_address1 ?? "Street1")\nStreet2: \(txt_st_address2 ?? "Street2")\nCity: \(txt_city ?? "City")\nProvince: \(txt_province ?? "Province")\nPostal: \(txt_postal ?? "Postal")\nCity: \(txt_country ?? "country")", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.updateUserData(txt_fname:txt_fname!, txt_lname: txt_lname!, txt_email:txt_email!, txt_phone: txt_phone!, txt_st_address1: txt_st_address1!, txt_st_address2: txt_st_address2!, txt_postal: txt_postal!, txt_province: txt_province!, txt_city: txt_city!, txt_country: txt_country!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        confirmationMessage.addAction(confirm)
        confirmationMessage.addAction(cancel)
        
        self.present(confirmationMessage, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     - Function: getUserData()
     - Description: Obtains current user data from Firebase and displays in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserData() {
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
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            self.txtfName.text = document.data()["fName"] as? String
                            self.txtlName.text = document.data()["lName"] as? String
                            self.txtEmail.text = document.data()["email"] as? String
                            self.txtphoneNo.text = document.data()["phone"] as? String
                            self.txtStAddress1.text = document.data()["street1"] as? String
                            self.txtStAddress2.text = document.data()["street2"] as? String
                            self.txtCity.text = document.data()["city"] as? String
                            self.txtProvince.text = document.data()["province"] as? String
                            self.txtPostal.text = document.data()["postal"] as? String
                            self.txtCountry.text = document.data()["country"] as? String
                        }
                    }
                }
        }
        
    }
    
    /*--------------------------------------------------------------------
     - Function:updateUserData()
     - Description: Gets user from Firestore using email and updates data.
     -------------------------------------------------------------------*/
    func updateUserData(txt_fname: String, txt_lname: String, txt_email: String, txt_phone: String, txt_st_address1: String, txt_st_address2: String, txt_postal: String, txt_province: String, txt_city: String, txt_country: String) {
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
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let ref = document.reference
 
                            Auth.auth().currentUser?.updateEmail(to: txt_email) { (error) in
                                
                            }
                            
                            ref.updateData([
                                "fName": txt_fname,
                                "lName": txt_lname,
                                "email": txt_email,
                                "phone": txt_phone,
                                "street1": txt_st_address1,
                                "street2": txt_st_address2,
                                "city": txt_city,
                                "postal": txt_postal,
                                "province": txt_province,
                                "country": txt_country
                            ]);
                        }
                    }
                }
        }
    }
}
