//
//  CodingUserInfoKeyExtension.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-09-15.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: extension CodingUserInfoKey
 - Description: extension to assist with Core Data.
 -----------------------------------------------------------------------*/
public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
