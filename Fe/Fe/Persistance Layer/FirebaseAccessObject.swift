//
//  DatabaseAccessObject.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-21.
//

// Imports
import Foundation
import Firebase

/*------------------------------------------------------------------------
 - Class: FirebaseAccessObject
 - Description: Holds methods for accessing Firebase Data
 -----------------------------------------------------------------------*/
class FirebaseAccessObject {
    
    // Class Variables
    let db = Firestore.firestore() // Access to Firestore Database
    
    /*--------------------------------------------------------------------
     - Function: checkIfNewUser()
     - Description: Checks if the user already exists in the Database.
     If the user doesn't exist, create a blank profile for them.
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
     - Description: Logic to add user to Firebase Firestore
     -------------------------------------------------------------------*/
    func addNewUser() {
        let user = Auth.auth().currentUser
        // TODO: - Change this to use the struct model User
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "uid": user!.uid,
            "fName": "",
            "lName": "",
            "age": "",
            "email": user!.email!,
            "password": "",
            "street1": "",
            "street2": "",
            "city": "",
            "postal": "",
            "province": "",
            "country": "",
            "existingSymptoms": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadFile()
     - Description: Logic to upload image to Firebase.
     -------------------------------------------------------------------*/
    func uploadFile(testName:String, imagePicked:UIImageView, date:String, doctor:String, results:String, notes:String) -> Bool {
        
        // Get the user email and check if they are already in the storage system
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: user!.email!)
        
        let date = date // Get DatePicker date
        
        // Get test Name for file path
        var fileName = ""
        if testName == "" {
                fileName = "NOFILENAME"
        } else {
            fileName = (testName)
        }
        
        let uploadRef = Storage.storage().reference(withPath: "\(String(describing: user!.email!))/\(date)/\(fileName).jpg")
        let imageData = (imagePicked.image?.jpegData(compressionQuality: 0.75))!
        
        let metadata = [
            "date" : "\(date)",
            "doctor" : "\(doctor)",
            "testResults" : "\(results)",
            "notes" : "\(notes)"
        ]
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        uploadMetadata.customMetadata = metadata
        
        var err = 0
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Error uploading picture: \(error.localizedDescription)")
                err += 1
            }
            // print("Put is complete and i got this back: \(String(describing: downloadMetadata))")
        }
        if err == 0 {
            return true
        } else {
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: countAllDocuments()
     - Description: returns number of pictures uploaded.
     -------------------------------------------------------------------*/
    func countAllDocuments() -> Int {
        var counter = 0
        
        let user = Auth.auth().currentUser
        let storage = Storage.storage()
        let storageReference = storage.reference().child((user?.email!)!)
        storageReference.listAll { (result, error) in
            if let error = error {
                print("There was an error retrieving list of emails: ", error)
            }
            for prefix in result.prefixes {
                // print(prefix.name)
                let storageRef = storage.reference().child("\((user?.email!)!)/\(prefix.name)")
                
                storageRef.listAll { (result, error) in
                    if let error = error {
                        print("There was an error retrieving files in date folder: ", error)
                    }
//                    for item in result.items {
//                        print(item.name)
//                    }
                    print("Counter: \(result.items.count)")
                    counter = counter + result.items.count
                }
            }
        }
        print("Final Count: \(counter)")
        return counter
    }
    
    /*--------------------------------------------------------------------
     - Function:
     - Description:
     -------------------------------------------------------------------*/
    
}
