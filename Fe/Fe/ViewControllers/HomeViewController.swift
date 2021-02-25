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
class HomeViewController: UIViewController, UITableViewDataSource {
    
    // Class Variables
    let data = ["HR", "BldOx", "Alt", "ViewDoc", "CheckSymp", "UploadDoc"]
    @IBOutlet var table : UITableView!
    
    /*--------------------------------------------------------------------
     - Function: tableView(number of rows)
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /*--------------------------------------------------------------------
     - Function: tableview(cellforRowAt)
     - Description: creates and configures the cell
     -------------------------------------------------------------------*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identfier, for: indexPath) as! HomeTableViewCell
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // Set up button on screen. To be removed.
    private let hrbutton : SensorCustomButton = {
        let button = SensorCustomButton(frame: CGRect(x:0, y:0, width:150, height:150))
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // Class Variables
    let db = Firestore.firestore()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some logic here if needed
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identfier)
        table.dataSource = self
        self.checkIfNewUser() // Add User to Firebase Table if New
        
        // Create Custom button
        let viewModel = SensorCustomButtonViewModel(mainTitle: "Heart Rate", currentSubtitle: "Current: 75 BPM", averageSubtitle: "Average: 82 BPM", imageName: "cart")
        let hrButton = SensorCustomButton(with: viewModel)
        hrButton.frame = CGRect(x:0, y:0, width:200, height:200)
        view.addSubview(hrbutton)
        hrbutton.center = view.center
        hrButton.layer.cornerRadius = 10
        hrbutton.configure(with: viewModel)
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

/*------------------------------------------------------------------------
 - Extension: HomeViewController : HomeTableViewCellDelegate
 - Description: Decides which function to call based on Cell Tapped
 -----------------------------------------------------------------------*/
extension HomeViewController : HomeTableViewCellDelegate {
    func didTapButton(with title: String) {
        print("\(title)")
    }
    // If title == HR, segue
    // If title == Alt, segue
    // If title == BldOx, segue
    // If title == Docs, segue
    // If title == upload, segue
    // If title == moreInf, segue
}
