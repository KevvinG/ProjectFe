//
//  DocumentTableTableViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: DocumentTableTableViewController : UITableViewController
 - Description: Holds the logic to show the whole table of documents
 -----------------------------------------------------------------------*/
class DocumentTableTableViewController: UITableViewController {
    
    // Class Variables
    var documentArray = [Document]()

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseAccessObject().iterateDocuments(completion: { docArray in
            self.documentArray = docArray
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
        
        let pressGesture : UITapGestureRecognizer = UITapGestureRecognizer(target : self, action: #selector(self.handleDocumentTapped))
        self.tableView.addGestureRecognizer(pressGesture)
    }
    
    /*--------------------------------------------------------------------
     - Function: viewDidAppear()
     - Description: Called when the view is shown to the user.
     -------------------------------------------------------------------*/
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    /*--------------------------------------------------------------------
     - Function: viewDidAppear()
     - Description: Called when the view is shown to the user.
     -------------------------------------------------------------------*/
    @objc func handleDocumentTapped(_ gestureRecognizer: UITapGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.displayViewDocument(indexPath : indexPath)
            }
        }
    }

    /*--------------------------------------------------------------------
     - Function: numberOfSections()
     - Description: Returns number of sections (1)
     -------------------------------------------------------------------*/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description: Returns number of documents in Firebase for user.
     -------------------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }
    
    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description: Prevents User from Editing Row.
     -------------------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description:
     -------------------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_document", for: indexPath) as! DocumentTableViewCell
        if indexPath.row < documentArray.count {
            let document = documentArray[indexPath.row]
            cell.lblTitle?.text = document.name
            cell.lblDate?.text = document.date
        }
        return cell
    }
    
    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description: Call function to delete Document from Storage
     -------------------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < documentArray.count {
            print("TODO: Write logic to delete from Firebase")
            // remove document from Array
            documentArray.remove(at: indexPath.row)
            // Call FirebaseAccessObject()  and delete Document(withPath:)
            tableView.reloadData()
        }
    }
    
    /*--------------------------------------------------------------------
     - Function: displayViewDocument()
     - Description: Shows New View Controller with specified document.
     -------------------------------------------------------------------*/
    private func displayViewDocument(indexPath: IndexPath) {
        let document = documentArray[indexPath.row]

        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let documentviewVC = mainSB.instantiateViewController(withIdentifier: "ViewDocument") as! DocumentviewViewController
        documentviewVC.document = document
        navigationController?.pushViewController(documentviewVC, animated: true)
    }
}
