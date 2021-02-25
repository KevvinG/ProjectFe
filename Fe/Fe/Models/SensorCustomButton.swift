//
//  SensorCustomButton.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-24.
//

//Imports
import UIKit

/*------------------------------------------------------------------------
 - Extension: SensorCustomButton : UIButton
 - Description: Holds logic for the custom button
 -----------------------------------------------------------------------*/
class SensorCustomButton : UIButton {
    
    // Main Title
    private let sensorTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // Current Label
    private let sensorCurrentLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // Average Label
    private let sensorAverageLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // Image
    private var sensorImage : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private var viewModel : SensorCustomButtonViewModel?
    
    /*--------------------------------------------------------------------
     - Function: init
     - Description: Creates button without viewModel
     -------------------------------------------------------------------*/
    override init(frame: CGRect) {
        self.viewModel = nil
        super.init(frame: frame)
    }
    
    /*--------------------------------------------------------------------
     - Function: init
     - Description: Creates button with viewModel
     -------------------------------------------------------------------*/
    init(with viewModel: SensorCustomButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        addSubviews()
        configure(with: viewModel)
    }
    
    
    /*--------------------------------------------------------------------
     - Function: addSubviews()
     - Description: Adds labels to button
     -------------------------------------------------------------------*/
    private func addSubviews() {
        guard !sensorTitleLabel.isDescendant(of: self) else {
            return
        }
        addSubview(sensorTitleLabel)
        addSubview(sensorCurrentLabel)
        addSubview(sensorAverageLabel)
        addSubview(sensorImage)
    }
    
    /*--------------------------------------------------------------------
     - Function: init?
     - Description: Checks for Error implementing the button.
     -------------------------------------------------------------------*/
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*--------------------------------------------------------------------
     - Function: configure
     - Description: Sets the button UI features and links to viewModel
     -------------------------------------------------------------------*/
    public func configure(with viewModel: SensorCustomButtonViewModel) {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.borderColor = UIColor.black.cgColor
        addSubviews()
        
        sensorTitleLabel.text = viewModel.mainTitle
        sensorCurrentLabel.text = viewModel.currentSubtitle
        sensorAverageLabel.text = viewModel.averageSubtitle
        sensorImage.image = UIImage(systemName: viewModel.imageName)
    }

    /*--------------------------------------------------------------------
     - Function: layoutSubviews()
     - Description: Sets button x,y,width,height of each item in the button.
     -------------------------------------------------------------------*/
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
         [     title      ]
         [     image      ]
         [    current     ]
         [    average     ]
         */
        sensorTitleLabel.frame = CGRect(x:0, y:-20, width: frame.width, height: (frame.height/2)).integral
        sensorImage.frame = CGRect(x:50, y:40, width: 50, height: 50 ).integral
        sensorCurrentLabel.frame = CGRect(x:0, y:95, width: frame.width, height: (frame.height)/4).integral
        sensorAverageLabel.frame = CGRect(x:0, y:115, width: frame.width, height: (frame.height)/4).integral

    }
}

/*------------------------------------------------------------------------
 - Struct: SensorCustomButtonViewModel
 - Description: holds information for button
 -----------------------------------------------------------------------*/
struct SensorCustomButtonViewModel {
    let mainTitle : String
    let currentSubtitle : String
    let averageSubtitle : String
    let imageName : String
}
