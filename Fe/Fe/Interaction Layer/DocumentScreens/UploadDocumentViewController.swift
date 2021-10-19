//
//  UploadDocumentViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: UploadDocumentViewController : UIViewController
 - Description: Screen to upload Document to system
 -----------------------------------------------------------------------*/
class UploadDocumentViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var txtTestName: UITextField!
    @IBOutlet var docDatePicker: UIDatePicker!
    @IBOutlet var txtDoctorName: UITextField!
    @IBOutlet var txtTestResults: UITextField!
    @IBOutlet var Notes: UITextField!
    @IBOutlet var imagePicked: UIImageView!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Initialize some code beforee showing screen.
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        createDatePicker()
        
        // Tap Gesture to close the onscreen keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
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
        
        self.txtTestName.inputAccessoryView = toolbar
        self.txtDoctorName.inputAccessoryView = toolbar
        self.txtTestResults.inputAccessoryView = toolbar
    }
    
    /*--------------------------------------------------------------------
     //MARK: doneButtonTapped()
     - Description: Selector for finishing keyboard editiing.
     -------------------------------------------------------------------*/
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: createDatePicker()
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
     //MARK: getDatePickerString()
     - Description: gets the string of the datePicker
     -------------------------------------------------------------------*/
    func getDatePickerString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: docDatePicker.date)
        return selectedDate
    }
    
    /*--------------------------------------------------------------------
     //MARK: takePictureBtnTapped()
     - Description: Opens phonoe camera if available.
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
     //MARK: findFileBtnTapped()
     - Description: Opens photo library to pick image if available.
     -------------------------------------------------------------------*/
    @IBAction func findDocumentBtnTapped(_ sender: Any) {
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
     //MARK: uploadBtnTapped()
     - Description: uploads image to Firebase Storage
     -------------------------------------------------------------------*/
    @IBAction func uploadBtnTapped(_ sender: Any) {
        if imagePicked.image == nil {
            // Show Alert to pick an image first
            let errorMessage = UIAlertController(title: "Error!", message: "Please take a picture or select one from the gallery first!", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorMessage.addAction(confirm)
            self.present(errorMessage, animated: true, completion: nil)
        } else {
            // Try to upload the picture to Firebase
            let objFB = FirebaseAccessObject()
            let success = objFB.uploadDocument(testName: txtTestName.text!, imagePicked: imagePicked, date: getDatePickerString(), doctor: txtDoctorName.text!, results: txtTestResults.text!, notes: Notes.text!)
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
 //MARK: UploadDocumentViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
 - Description: Functions to handle image picker.
 -----------------------------------------------------------------------*/
extension UploadDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*--------------------------------------------------------------------
     //MARK: imagePickerControllerDidCancel()
     - Description: Dismiss the picker controller.
     -------------------------------------------------------------------*/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*--------------------------------------------------------------------
     //MARK: imagePickerController()
     - Description: Handles when a picture is chosen on camera or photo library.
     -------------------------------------------------------------------*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
    }
}
