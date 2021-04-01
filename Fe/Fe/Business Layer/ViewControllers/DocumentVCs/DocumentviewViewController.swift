//
//  DocumentviewViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-21.
//

// Imports
import UIKit
import Firebase

/*------------------------------------------------------------------------
 - Class: DocumentviewViewController : UIViewController
 - Description: Shows the image downloaded from Firebase.
 -----------------------------------------------------------------------*/
class DocumentviewViewController: UIViewController {
    
    // UI Variables
    @IBOutlet var imgView: UIImageView!
    
    // Class Variables
    var document : Document?

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: MOVE TO FIREBASEACCESSOBJECT.GETIMAGE(doc: Document) -> ?
        let pathReference = Storage.storage().reference(withPath: document!.location)
        let placeholderImage = UIImage(named: "placeholder.jpg") // Placeholder
        imgView.sd_setImage(with: pathReference, placeholderImage: placeholderImage) // load Image
    }
}
