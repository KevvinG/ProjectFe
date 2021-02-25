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
    
    func sensorButton(mainTitle: String, currentSubtitle: String, averageSubtitle: String, imageName: String) -> SensorCustomButton {
        let button = SensorCustomButton(frame: CGRect(x:0, y:0, width:150, height:150))
        button.addTarget(self, action: #selector(heartRateBtnTapped), for: .touchUpInside)
        return button
    }

    // Set up button on screen. To be removed.
    private let hrbutton : SensorCustomButton = {
        let button = SensorCustomButton(frame: CGRect(x:0, y:0, width:150, height:150))
        button.addTarget(self, action: #selector(heartRateBtnTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func heartRateBtnTapped(sender: UIButton!) {
        print("Tapped")
    }
    
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
        let vmHrBtn = SensorCustomButtonViewModel(mainTitle: "Heart Rate", currentSubtitle: "Current: 75 BPM", averageSubtitle: "Average: 82 BPM", imageName: "heart")
        view.addSubview(hrbutton)
        hrbutton.center = view.center
        hrbutton.configure(with: vmHrBtn)
    }
    
    /*--------------------------------------------------------------------
     - Function: createButton()
     - Description: Prepare any code before changing scenes.
     -------------------------------------------------------------------*/
    func createButton(buttonName: String, title: String, currentSubtitle: String, averageSubtitle: String, imageName: String) {
        let viewModel = SensorCustomButtonViewModel(mainTitle: title, currentSubtitle: currentSubtitle, averageSubtitle: averageSubtitle, imageName: imageName)
        let buttonName = SensorCustomButton(with: viewModel)
        buttonName.frame = CGRect(x:0, y:0, width:200, height:200)
        view.addSubview(buttonName)
        buttonName.layer.cornerRadius = 10
        buttonName.configure(with: viewModel)
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
