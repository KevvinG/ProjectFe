//
//  DocumentviewViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-21.
//

// Imports
import UIKit

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
        
        print("TODO: Display Image")
//        imgView.image = document?.location
    }

}
