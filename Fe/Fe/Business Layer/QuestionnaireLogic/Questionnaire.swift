//
//  Questionnaire.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-04-16.
//

import Foundation

class Questionnaire {
    
    func callDoctor(completion: @escaping (_ doctorPhone: String) -> Void) {
        FirebaseAccessObject().fetchDoctorPhoneNumber( completion: { (phone) -> Void in
            completion(phone)
        })
    }
}
