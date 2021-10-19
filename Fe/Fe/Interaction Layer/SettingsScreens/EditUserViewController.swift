//
//  EditUserViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-17.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: EditUserViewController : UIViewController
 - Description: Holds logic for the User Account Settings Screen
 -----------------------------------------------------------------------*/
class EditUserViewController: UIViewController {
    
    // UI Variables
    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var txtlName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtphoneNo: UITextField!
    @IBOutlet weak var txtStAddress1: UITextField!
    @IBOutlet weak var txtStAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtExistingSymptoms: UITextField!
    
    let provinces = [
        "BC", "AB", "MB", "NB", "NL",
        "NS", "NT", "NU", "ON", "PE",
        "QC", "SK", "YT"
    ]
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserData()
        self.setupTextFields()
        
        // Tap Gesture to close the onscreen keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupTextFields()
     - Description: Set up keyboard for text field.
     -------------------------------------------------------------------*/
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.txtfName.inputAccessoryView = toolbar
        self.txtlName.inputAccessoryView = toolbar
        self.txtAge.inputAccessoryView = toolbar
        self.txtEmail.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
        self.txtphoneNo.inputAccessoryView = toolbar
        self.txtStAddress1.inputAccessoryView = toolbar
        self.txtStAddress2.inputAccessoryView = toolbar
        self.txtCity.inputAccessoryView = toolbar
        self.txtPostal.inputAccessoryView = toolbar
        self.txtProvince.inputAccessoryView = toolbar
        self.txtCountry.inputAccessoryView = toolbar
        self.txtExistingSymptoms.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: Selector for finishing keyboard editiing.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: saveChangeBtnTapped()
     - Description: Finds the user information in Firestore then updates.
     -------------------------------------------------------------------*/
    @IBAction func saveChangesBtnTapped(_ sender: UIButton) {
        
        let txt_fname = txtfName.text
        let txt_lname = txtlName.text
        let txt_age = txtAge.text
        let txt_email = txtEmail.text
        let txt_password = txtPassword.text
        let txt_phone = txtphoneNo.text
        let txt_st_address1 = txtStAddress1.text
        let txt_st_address2 = txtStAddress2.text
        let txt_city = txtCity.text
        let txt_province = txtProvince.text
        let txt_postal = txtPostal.text
        let txt_country = txtCountry.text
        let txt_ex_symptoms = txtExistingSymptoms.text
        
        let confirmationMessage = UIAlertController(title: "Data Confirmation", message: "New information:\nFirst Name: \(txt_fname ?? "First Name")\nLast Name: \(txt_lname ?? "Last Name")\nAge: \(txt_age ?? "Age")\nEmail: \(txt_email ?? "Email")\nPassword: \(txt_password ?? "Password")\nPhone: \(txt_phone ?? "Phone")\nStreet 1: \(txt_st_address1 ?? "Street1")\nStreet2: \(txt_st_address2 ?? "Street2")\nCity: \(txt_city ?? "City")\nProvince: \(txt_province ?? "Province")\nPostal: \(txt_postal ?? "Postal")\nCity: \(txt_country ?? "country")\nSymptoms: \(txt_ex_symptoms ?? "Symptoms")", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.updateUserData(fname: txt_fname!, lname: txt_lname!, age: txt_age!, email: txt_email!, password: txt_password!, phone: txt_phone!, st_address1: txt_st_address1!, st_address2: txt_st_address2!, postal: txt_postal!, province: txt_province!, city: txt_city!, country: txt_country!, symptoms: txt_ex_symptoms!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        confirmationMessage.addAction(confirm)
        confirmationMessage.addAction(cancel)
        
        self.present(confirmationMessage, animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     //MARK: getUserData()
     - Description: Calls Firebase method and displays data in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserData() {
        FirebaseAccessObject().getUserData(completion: { userData in
            self.txtfName.text = userData["fName"]
            self.txtlName.text = userData["lName"]
            self.txtAge.text = userData["age"]
            self.txtEmail.text = userData["email"]
            self.txtPassword.text = userData["password"]
            self.txtphoneNo.text = userData["phone"]
            self.txtStAddress1.text = userData["street1"]
            self.txtStAddress2.text = userData["street2"]
            self.txtCity.text = userData["city"]
            self.txtProvince.text = userData["province"]
            self.txtPostal.text = userData["postal"]
            self.txtCountry.text = userData["country"]
            self.txtExistingSymptoms.text = userData["existingSymptoms"]
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateUserData()
     - Description: Calls method in Firestore to update database
     -------------------------------------------------------------------*/
    func updateUserData(fname: String, lname: String, age: String, email: String, password: String, phone: String, st_address1: String, st_address2: String, postal: String, province: String, city: String, country: String, symptoms: String) {
        FirebaseAccessObject().updateUserData(fname: fname, lname: lname, age: age, email: email, password: password, phone: phone, st_address1: st_address1, st_address2: st_address2, postal: postal, province: province, city: city, country: country, symptoms: symptoms)
    }
}
