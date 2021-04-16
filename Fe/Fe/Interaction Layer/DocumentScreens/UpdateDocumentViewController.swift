//
//  UpdateDocumentViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-04-03.
//

// Imports
import UIKit
import Firebase

/*------------------------------------------------------------------------
 - Class: UpdateDocumentViewController : UIViewController
 - Description: Screen to update Document
 -----------------------------------------------------------------------*/
class UpdateDocumentViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var docDatePicker: UIDatePicker!
    @IBOutlet var txtTestName: UITextField!
    @IBOutlet var txtDrName: UITextField!
    @IBOutlet var txtResults: UITextField!
    @IBOutlet var txtNotes: UITextField!
    
    // Class Variables
    var document : Document?
    
    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize some code before showing screen.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        setDocumentDetails()
    }
    
    /*--------------------------------------------------------------------
     - Function: createDatePicker()
     - Description: Set datepicker options
     -------------------------------------------------------------------*/
    func createDatePicker() {
        docDatePicker.datePickerMode = .date
        docDatePicker.maximumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     - Function: getDatePickerString()
     - Description: gets the string of the datePicker
     -------------------------------------------------------------------*/
    func getDatePickerString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: docDatePicker.date)
        return selectedDate
    }
    
    /*--------------------------------------------------------------------
     - Function: setDocumentDetails()
     - Description: sets Document Details from passed document.
     -------------------------------------------------------------------*/
    func setDocumentDetails() {
        //TODO: MOVE TO FIREBASEACCESSOBJECT.GETIMAGE(doc: Document) -> ?
        let pathReference = Storage.storage().reference(withPath: document!.location)
        let placeholderImage = UIImage(named: "placeholder.jpg") // Placeholder
        imgView.sd_setImage(with: pathReference, placeholderImage: placeholderImage) // load Image
        
        // Grab Date from Document
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let date = dateFormatter.date(from: document!.date)
        print(document!.date)
        
        // Remove .jpg from file name
        var fileName = document!.name
        var components = fileName.components(separatedBy: ".")
        if components.count > 1 { // If there is a file extension
            components.removeLast()
            fileName = components[0]
        }

        docDatePicker.setDate(date!, animated: false)
        txtTestName.text = fileName
        txtDrName.text = self.document?.doctor
        txtResults.text = document?.testResults
        txtNotes.text = document?.notes
    }
    
    /*--------------------------------------------------------------------
     - Function: takePictureBtnTapped()
     - Description: Opens Camera to take picture.
     -------------------------------------------------------------------*/
    @IBAction func takePictureBtnTapped(_ sender: Any) {
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
     - Function: findPictureBtnTapped()
     - Description: Opens Gallery to choose picture.
     -------------------------------------------------------------------*/
    @IBAction func findPictureBtnTapped(_ sender: Any) {
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
     - Function: updateDocumentBtnTapped()
     - Description: Updates document in Firebase
     -------------------------------------------------------------------*/
    @IBAction func updateDocumentBtnTapped(_ sender: Any) {
        if imgView.image == nil {
            // Show Alert to pick an image first
            let errorMessage = UIAlertController(title: "Error!", message: "Please take a picture or select one from the gallery first!", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorMessage.addAction(confirm)
            self.present(errorMessage, animated: true, completion: nil)
        } else {
            let objFB = FirebaseAccessObject()
            // Delete Old Document, then upload new one.
            objFB.deleteDocument(doc: self.document)
            // Upload New Document
            let success = objFB.uploadFile(testName: txtTestName.text!, imagePicked: imgView, date: getDatePickerString(), doctor: txtDrName.text!, results: txtResults.text!, notes: txtNotes.text!)
            if success {
                // Show Alert that image was saved
                let confirmationMessage = UIAlertController(title: "Picture Saved!", message: "Your picture has beed saved", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
                confirmationMessage.addAction(confirm)
                self.present(confirmationMessage, animated: true, completion: nil)
            } else {
                // Error dialog
                let errorMessage = UIAlertController(title: "Upload Unsuccessful!", message: "Your picture could not be uploaded", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorMessage.addAction(confirm)
                self.present(errorMessage, animated: true, completion: nil)
            }
        }
    }
}

/*------------------------------------------------------------------------
 - Class: UploadDocumentViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
 - Description: Functions to handle image picker.
 -----------------------------------------------------------------------*/
extension UpdateDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*--------------------------------------------------------------------
     - Function: imagePickerControllerDidCancel()
     - Description: Dismiss the picker controller.
     -------------------------------------------------------------------*/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     - Function: imagePickerController()
     - Description: Handles when a picture is chosen on camera or photo library.
     -------------------------------------------------------------------*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        imgView.image = image
        dismiss(animated: true, completion: nil)
    }
}
