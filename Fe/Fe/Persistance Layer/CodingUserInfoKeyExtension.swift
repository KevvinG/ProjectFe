//
//  CodingUserInfoKeyExtension.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-09-15.
//

//MARK: Imports
import Foundation

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
