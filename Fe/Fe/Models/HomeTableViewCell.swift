//
//  HomeTableViewCell.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-24.
//

import UIKit

protocol HomeTableViewCellDelegate : AnyObject {
    func didTapButton(with title: String)
}

class HomeTableViewCell: UITableViewCell {
    
    weak var delegate : HomeTableViewCellDelegate?
    
    static let identfier = "HomeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeTableViewCell", bundle: nil)
    }
    
    @IBOutlet var button: UIButton!
    private var title: String = ""
    
    @IBAction func didTapButton() {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String) {
        self.title = title
        button.setTitle(title, for: .normal)
        
    }
    
    // Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(.link, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
