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
    @IBOutlet var imagePicked: UIImageView!
    
    
    
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
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            print("Camera not available.")
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: findFileBtnTapped()
     - Description: Opens photo library to pick image
     -------------------------------------------------------------------*/
    @IBAction func findFileBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
        } else {
            print("Photo Library not available.")
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: uploadBtnTapped()
     - Description: 
     -------------------------------------------------------------------*/
    @IBAction func uploadBtnTapped(_ sender: Any) {
        if imagePicked.image == nil {
            // Show Alert to pick an image first
            let errorMessage = UIAlertController(title: "Error!", message: "Please take a picture or select one from the gallery first!", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorMessage.addAction(confirm)
            self.present(errorMessage, animated: true, completion: nil)
        } else {
            // Get the user email and check if they are already in the storage system
            let user = Auth.auth().currentUser
            let usersRef = db.collection("users")
            usersRef.whereField("email", isEqualTo: user?.email ?? "NOEMAIL")
            
            // Get DatePicker date
            let date = getDatePickerString()
            
            let uploadRef = Storage.storage().reference(withPath: "\(String(describing: user?.email))/\(date)/\(String(describing: txtTestName.text)).jpg")
            
            guard let imageData = imagePicked.image?.jpegData(compressionQuality: 0.75) else { return }
            
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            
            uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let error = error {
                    print("Error uploading picture: \(error.localizedDescription)")
                    return
                }
                print("Put is complete and i got this back: \(String(describing: downloadMetadata))")
            }
            
            // Show Alert that image was saved
            let confirmationMessage = UIAlertController(title: "Picture Saved!", message: "Your picture has beed saved", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
            confirmationMessage.addAction(confirm)
            self.present(confirmationMessage, animated: true, completion: nil)
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
    
    /*--------------------------------------------------------------------
     - Function: imagePickerController()
     - Description: Handles when a picture is chosen on camera or photo library.
     -------------------------------------------------------------------*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
    }
}
