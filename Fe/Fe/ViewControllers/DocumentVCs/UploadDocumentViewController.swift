//
//  UploadDocumentViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit
import Firebase

/*------------------------------------------------------------------------
 - Class: UploadDocumentViewController : UIViewController
 - Description: Screen to upload Document to system
 -----------------------------------------------------------------------*/
class UploadDocumentViewController: UIViewController {

    // Class Variables
    let db = Firestore.firestore()
    
    // UI Variables
    @IBOutlet var txtTestName: UITextField!
    @IBOutlet var docDatePicker: UIDatePicker!
    @IBOutlet var txtDoctorName: UITextField!
    @IBOutlet var txtTestResults: UITextField!
    @IBOutlet var Notes: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some code beforee showing screen.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    /*--------------------------------------------------------------------
     - Function: createDatePicker()
     - Description: Set datepicker options
     -------------------------------------------------------------------*/
    func createDatePicker() {
        docDatePicker.datePickerMode = .dateAndTime
        docDatePicker.maximumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let strDate = dateFormatter.string(from: docDatePicker.date)
        self.view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     - Function: getDatePickerString()
     - Description: gets the string of the datePicker
     -------------------------------------------------------------------*/
    func getDatePickerString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let strDate = dateFormatter.string(from: docDatePicker.date)
        return strDate
    }
    
    /*--------------------------------------------------------------------
     - Function: getDatePickerString()
     - Description: gets the string of the datePicker
     -------------------------------------------------------------------*/
    @IBAction func takePictureBtnTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadBtnTapped()
     - Description: 
     -------------------------------------------------------------------*/
    func uploadBtnTapped() {
        // Get the user email and check if they are already in the storage system
        let user = Auth.auth().currentUser
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
        
        // Get DatePicker date
        let date = getDatePickerString()
        
        let uploadRef = Storage.storage().reference(withPath: "\(String(describing: user?.email))/\(date)\(String(describing: txtTestName.text)).jpg")
        
        guard let imageData = imgView.image?.jpegData(compressionQuality: 0.75) else { return }
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Error uploading picture: \(error.localizedDescription)")
                return
            }
            print("Put is complete and i got this back: \(String(describing: downloadMetadata))")
        }
    }
}

/*------------------------------------------------------------------------
 - Class: UploadDocumentViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
 - Description: Functions to handle image picker.
 -----------------------------------------------------------------------*/
extension UploadDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imgView.image = image
    }
}
