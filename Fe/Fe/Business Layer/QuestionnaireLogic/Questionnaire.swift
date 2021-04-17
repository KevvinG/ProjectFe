//
//  Questionnaire.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-04-16.
//

// Imports
import Foundation

/*------------------------------------------------------------------------
 - Class: Questionnaire
 - Description:
 -----------------------------------------------------------------------*/
class Questionnaire {
    
    /*--------------------------------------------------------------------
     - Function: callDoctor()
     - Description: fetch doctor phone number and open menu to call.
     -------------------------------------------------------------------*/
    func callDoctor(completion: @escaping (_ doctorPhone: String) -> Void) {
        FirebaseAccessObject().fetchDoctorPhoneNumber( completion: { (phone) -> Void in
            completion(phone)
        })
    }
}
