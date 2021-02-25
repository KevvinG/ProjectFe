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
 - Class: HomeViewController : UIViewController, UITableViewDataSource
 - Description: Holds logic for the the User Home Screen
 -----------------------------------------------------------------------*/
class HomeViewController: UIViewController {

    // Set up button on screen. To be removed.
//    private let hrbutton : SensorCustomButton = {
//        let button = SensorCustomButton(frame: CGRect(x:0, y:0, width:150, height:150))
//        button.addTarget(self, action: #selector(heartRateBtnTapped), for: .touchUpInside)
//        return button
//    }()
//
//    @objc func heartRateBtnTapped(sender: UIButton!) {
//        print("Tapped")
//    }
    
    // Class Variables
    let db = Firestore.firestore()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIfNewUser() // Add User to Firebase Table if New
        
        // Create Custom button
//        let vmHrBtn = SensorCustomButton(mainTitle: "Heart Rate", currentSubtitle: "Current: 75 BPM", averageSubtitle: "Average: 82 BPM", imageName: "heart")
//        view.addSubview(hrbutton)
//        hrbutton.center = view.center
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
    
    /*--------------------------------------------------------------------
     - Function: heartRateBtnTapped()
     - Description: Segue to heartRate Data View
     -------------------------------------------------------------------*/
    @IBAction func heartRateBtnTapped(_ sender: UIButton) {
        
    }
    
    /*--------------------------------------------------------------------
     - Function: bloodOxygenBtnTapped()
     - Description: Segue to blood oxygen Data View
     -------------------------------------------------------------------*/
    @IBAction func bloodOxygenBtnTapped(_ sender: UIButton) {
        
    }
    
    /*--------------------------------------------------------------------
     - Function: altitudeBtnTapped()
     - Description: Segue to altitude Data View
     -------------------------------------------------------------------*/
    @IBAction func altitudeBtnTapped(_ sender: UIButton) {
        
    }
    
    /*--------------------------------------------------------------------
     - Function: viewDocumentsBtnTapped()
     - Description: Segue to viewDocuments table View
     -------------------------------------------------------------------*/
    @IBAction func viewDocumentsBtnTapped(_ sender: UIButton) {
        
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadDocumentBtnTapped()
     - Description: Segue to upload document view
     -------------------------------------------------------------------*/
    @IBAction func uploadDocumentBtnTapped(_ sender: UIButton) {
        
    }
    
    /*--------------------------------------------------------------------
     - Function: checkSymptomsBtnTapped()
     - Description: Segue to symptom Checking view
     -------------------------------------------------------------------*/
    @IBAction func checkSymptomsBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSymptomDizzy", sender: self)
    }
    
    /*--------------------------------------------------------------------
     - Function: moreInformationBtnTapped()
     - Description: Segue to more Information Webpage
     -------------------------------------------------------------------*/
    @IBAction func moreInformationBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToMoreInfoScreen", sender: self)
    }
    
}
