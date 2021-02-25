//
//  SensorCustomButton.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-24.
//

//Imports
import UIKit

/*------------------------------------------------------------------------
 - Class: SensorCustomButton : UIButton
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
    
    /*--------------------------------------------------------------------
     - Function: init
     - Description: Creates button without viewModel
     -------------------------------------------------------------------*/
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /*--------------------------------------------------------------------
     - Function: init?
     - Description: Checks for Error implementing the button.
     -------------------------------------------------------------------*/
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*--------------------------------------------------------------------
     - Function: layoutSubviews()
     - Description: Adds subviews
     -------------------------------------------------------------------*/
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setup()
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
     - Function: configure
     - Description: Sets the button UI features and links to viewModel
     -------------------------------------------------------------------*/
    private func setup()  {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.borderColor = UIColor.black.cgColor
        addSubviews()
    }
}
