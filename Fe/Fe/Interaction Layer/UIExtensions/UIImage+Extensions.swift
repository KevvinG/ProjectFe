//
//  UIImage+Extensions.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-11-24.
//

//MARK: Impoorts
import Foundation
import UIKit

/*------------------------------------------------------------------------
 //MARK: UIImage
 - Description: Extended method for image opacity
 -----------------------------------------------------------------------*/
public extension UIImage {
    
    /*--------------------------------------------------------------------
     //MARK: alpha()
     - Description: sets image opacity.
     -------------------------------------------------------------------*/
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
