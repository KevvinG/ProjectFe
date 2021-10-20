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
     //MARK: validateName()
     - Description: Ensure name is properly formatted.
     -------------------------------------------------------------------*/
    public func validateName(name: String) -> Bool {
        guard name.count < 40 else { return false }
        let regex = "[A-Za-z ]*"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateAge()
     - Description: Ensure age is properly formatted.
     -------------------------------------------------------------------*/
    public func validateAge(age: String) -> Bool {
        guard age.count <= 3 else { return false }
        let regex = "200|1[0-9]{2}|[0-9]{2}|[0-9]{1}|^$"
        let trimmedString = age.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateEmail()
     - Description: Ensure email is properly formatted.
     -------------------------------------------------------------------*/
    public func validateEmail(email: String) -> Bool {
        guard email.count > 0, email.count < 40 else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = email.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validatePassword()
     - Description: Ensure password is properly formatted.
     - At least 6 characters - one lower, one upper, one number
     -------------------------------------------------------------------*/
    public func validatePassword(password: String) -> Bool {
        guard password.count > 0, password.count < 20 else { return false }
        let regex = "^(?=^.{6,}$)((?=.*[A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z]))^.*$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validatePhoneNumber()
     - Description: Ensure phone number is properly formatted.
     -------------------------------------------------------------------*/
    public func validatePhoneNumber(phoneNumber: String) -> Bool {
        guard phoneNumber.count < 20 else { return false }
        let regex = #"^1\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$|^$"#
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateStreet()
     - Description: Ensure street address is properly formatted.
     -------------------------------------------------------------------*/
    public func validateStreet(street: String) -> Bool {
        guard street.count < 30 else { return false }
        let regex = "[A-Za-z0-9 ]*"
        let trimmedString = street.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateCity()
     - Description: Ensure city is properly formatted.
     -------------------------------------------------------------------*/
    public func validateCity(city: String) -> Bool {
        guard city.count < 30 else { return false }
        let regex = "^[a-zA-Z\u{0080}-\u{024F}\\s\\/\\-\\)\\(\\`\\.\\\"\\']*$|^$"
        let trimmedString = city.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateProvince()
     - Description: Ensure province is properly formatted.
     -------------------------------------------------------------------*/
    public func validateProvince(province: String) -> Bool {
        guard province.count < 20 else { return false }
        let regex = "^(?:ab|AB|Alberta|bc|BC|British Columbia|mb|MB|Manitoba|n[bltsu]|N[BLTSU]|on|ON|Ontario|pe|PE|Prince Edward Island|qc|QC|Quebec|sk|SK|Saskatchewan|yt|YT|Yukon|Yukon Territory)*$|^$"
        let trimmedString = province.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validatePostalCode()
     - Description: Ensure postal code is properly formatted.
     -------------------------------------------------------------------*/
    public func validatePostalCode(postal: String) -> Bool {
        guard postal.count < 8 else { return false }
        let regex = "^[ABCEGHJKLMNPRSTVXY][0-9][A-Z] [0-9][A-Z][0-9]$|^$"
        let trimmedString = postal.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateCountry()
     - Description: Ensure country is properly formatted.
     -------------------------------------------------------------------*/
    public func validateCountry(country: String) -> Bool {
        guard country.count < 25 else { return false }
        let regex = "^CA|Canada|canada|US|USA|United States$|^$"
        let trimmedString = country.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
    
    /*--------------------------------------------------------------------
     //MARK: validateSymptoms()
     - Description: Ensure symptoms is properly formatted.
     -------------------------------------------------------------------*/
    public func validateSymptoms(symptoms: String) -> Bool {
        guard symptoms.count < 50 else { return false }
        let regex = "[A-Za-z0-9,. ]*"
        let trimmedString = symptoms.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = validate.evaluate(with: trimmedString)
        return isValid
    }
}
