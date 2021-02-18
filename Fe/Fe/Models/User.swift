//
//  User.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-17.
//

import Foundation

public struct User : Codable {
    let UID : String?
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
