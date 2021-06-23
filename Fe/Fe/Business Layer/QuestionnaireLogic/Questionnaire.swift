//
//  Questionnaire.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-04-16.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Questionnaire
 - Description: Logic for Questionnaire.
 -----------------------------------------------------------------------*/
class Questionnaire {
    
    /*--------------------------------------------------------------------
     //MARK: callDoctor()
     - Description: fetch doctor phone number and open menu to call.
     -------------------------------------------------------------------*/
    func callDoctor(completion: @escaping (_ doctorPhone: String) -> Void) {
        FirebaseAccessObject().fetchDoctorPhoneNumber( completion: { (phone) -> Void in
            completion(phone)
        })
    }
}
