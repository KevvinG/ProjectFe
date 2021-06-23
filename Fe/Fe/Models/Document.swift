//
//  Document.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-03-21.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Document
 - Description: Structure for Firebase Document
 -----------------------------------------------------------------------*/
class Document {
    
    // Class Variables
    var name: String
    var size: String
    var type: String
    var testResults: String
    var doctor : String
    var date : String
    var notes : String
    var location : String
    
    /*--------------------------------------------------------------------
     //MARK: init
     - Description: initialize all variables
     -------------------------------------------------------------------*/
    init(name: String, size: String, type: String, testResults: String,
         doctor: String, date: String, notes: String, location: String) {
        self.name = name
        self.size = size
        self.type = type
        self.testResults = testResults
        self.doctor = doctor
        self.date = date
        self.notes = notes
        self.location = location
    }
}
