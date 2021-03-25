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

    /*--------------------------------------------------------------------
     - Function: viewDidLoad()
     - Description: Initialize
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        FirebaseAccessObject().countAllDocuments(completion: { count in
            print("Count Received: \(count)")
            //TODO: RETURN THIS NUMBER
        })
        return 0
    }
    
    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description: Prevents User from Editing Row.
     -------------------------------------------------------------------*/
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*--------------------------------------------------------------------
     - Function: tableView()
     - Description:
     -------------------------------------------------------------------*/

    
    /*--------------------------------------------------------------------
     - Function: displayViewDocument()
     - Description: Shows New View Controller with specified document.
     -------------------------------------------------------------------*/
    private func displayViewDocument(indexPath: IndexPath) {
//        let nsObj = ReceiptController.getAllReceipts()![ReceiptController.getAllReceipts()!.count - 1 - indexPath.row]
//        let receipt = ReceiptController.receiptFromNSManagedObject(obj: nsObj)
//
//        let mainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let documentviewVC = mainSB.instantiateViewController(withIdentifier: "ViewDocument") as! ViewReceiptVC
//        documentviewVC.document = document
//        navigationController?.pushViewController(documentviewVC, animated: true)
    }
    

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //TODO: Configure cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_document", for: indexPath) as! DocumentTableViewCell
//
//        return cell
//    }
    


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
