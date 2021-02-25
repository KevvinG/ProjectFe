//
//  HomeTableViewCell.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-24.
//

// Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: HomeTableViewCellDelegate : AnyObject
 - Description: Protocol for tapping cell buttons
 -----------------------------------------------------------------------*/
protocol HomeTableViewCellDelegate : AnyObject {
    func didTapButton(with title: String)
}

/*------------------------------------------------------------------------
 - Class: HomeTableViewCell : UITableViewCell
 - Description: Holds basic setup of the table view cell
 -----------------------------------------------------------------------*/
class HomeTableViewCell: UITableViewCell {
    
    // Class Variables
    weak var delegate : HomeTableViewCellDelegate?
    static let identfier = "HomeTableViewCell"
    private var title: String = ""
    @IBOutlet var button: UIButton!
    
    /*--------------------------------------------------------------------
     - Function: nib()
     - Description: Returns a nib (table cell)
     -------------------------------------------------------------------*/
    static func nib() -> UINib {
        return UINib(nibName: "HomeTableViewCell", bundle: nil)
    }
    
    /*--------------------------------------------------------------------
     - Function: didTapButton()
     - Description: If button tapped, bubble up to HomeViewController
     - extension to decide what happens next.
     -------------------------------------------------------------------*/
    @IBAction func didTapButton() {
        delegate?.didTapButton(with: title)
    }
    
    /*--------------------------------------------------------------------
     - Function: configure()
     - Description: Configure the cell
     -------------------------------------------------------------------*/
    func configure(with title: String) {
        self.title = title
        button.setTitle(title, for: .normal)
    }
    
    /*--------------------------------------------------------------------
     - Function: awakeFromNib()
     - Description: Initialize code here
     -------------------------------------------------------------------*/
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(.link, for: .normal)
    }

    /*--------------------------------------------------------------------
     - Function: setSelected()
     - Description: Sets the selected cells state with animation inbetween.
     -------------------------------------------------------------------*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
