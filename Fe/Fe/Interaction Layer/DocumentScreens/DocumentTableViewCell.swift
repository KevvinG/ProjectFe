//
//  DocumentTableViewCell.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit

/*------------------------------------------------------------------------
 //MARK: DocumentTableViewCell : UITableViewCell
 - Description: Holds the logic for each cell click
 -----------------------------------------------------------------------*/
class DocumentTableViewCell: UITableViewCell {
    
    // UI Variables
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDate : UILabel!

    /*--------------------------------------------------------------------
     //MARK: awakeFromNib()
     - Description: Initialization code
     -------------------------------------------------------------------*/
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /*--------------------------------------------------------------------
     //MARK: setSelected()
     - Description: Set up Cell.
     -------------------------------------------------------------------*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
