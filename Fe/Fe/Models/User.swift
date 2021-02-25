//
//  User.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-17.
//

// Imports
import Foundation

/*------------------------------------------------------------------------
 - Struct: User : Codable
 - Description: For use when fetching Users from Firestore
 -----------------------------------------------------------------------*/
public struct User : Codable {
    let uid : String?
    let email : String?
    let fName : String?
    let lName : String?
    let street1 : String?
    let street2 : String?
    let city : String?
    let postal : String?
    let province : String?
    let country : String?
}
