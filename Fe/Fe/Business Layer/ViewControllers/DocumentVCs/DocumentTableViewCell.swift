//
//  DocumentTableViewCell.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: DocumentTableViewCell : UITableViewCell
 - Description: Holds the logic for each cell click
 -----------------------------------------------------------------------*/
class DocumentTableViewCell: UITableViewCell {
    
    // UI Variables
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDate : UILabel!

    /*--------------------------------------------------------------------
     - Function: awakeFromNib()
     - Description: Initialization code
     -------------------------------------------------------------------*/
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /*--------------------------------------------------------------------
     - Function: setSelected()
     - Description: Set up Cell.
     -------------------------------------------------------------------*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
