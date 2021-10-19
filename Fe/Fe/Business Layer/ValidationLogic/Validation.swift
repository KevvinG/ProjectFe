//
//  Validation.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-10-19.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: validation
 - Description: Validation Functions for different inputs in the app.
 -----------------------------------------------------------------------*/
class Validation {
    
    /*--------------------------------------------------------------------
     //MARK: validateFirstName()
     - Description: Ensure first name is properly formatted.
     -------------------------------------------------------------------*/
    public func validateFirstName(fName: String) -> Bool {
        guard fName.count > 0, fName.count < 30 else { return false }
        let regex = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        let trimmedString = regex.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validatePhoneNumber()
     - Description: Ensure phone number is properly formatted.
     -------------------------------------------------------------------*/
    public func validatePhoneNumber(phoneNumber: String) -> Bool {
        let phoneNumberRegex = #"^1\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateEmail()
     - Description: Ensure email is properly formatted.
     -------------------------------------------------------------------*/
    public func validateEmail(email: String) -> Bool {
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        let trimmedString = email.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValidEmail = validateEmail.evaluate(with: trimmedString)
        return isValidEmail
    }
}
