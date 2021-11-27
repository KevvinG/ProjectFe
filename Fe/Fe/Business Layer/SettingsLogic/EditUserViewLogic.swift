//
//  EditUserViewLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Class EditUserViewLogic
 - Description: Holds logic for the Edit User Screen.
 -----------------------------------------------------------------------*/
public class EditUserViewLogic {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: getUserData()
     - Description: Retrieve user data from Firebase Function.
     -------------------------------------------------------------------*/
    func getUserData(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getUserData(completion: { userData in
            var dataDict = [String:String]()
            dataDict["fName"] = userData["fName"]
            dataDict["lName"] = userData["lName"]
            dataDict["age"] = userData["age"]
            dataDict["email"] = userData["email"]
            dataDict["password"] = userData["password"]
            dataDict["phone"] = userData["phone"]
            dataDict["street1"] = userData["street1"]
            dataDict["street2"] = userData["street2"]
            dataDict["city"] = userData["city"]
            dataDict["province"] = userData["province"]
            dataDict["postal"] = userData["postal"]
            dataDict["country"] = userData["country"]
            dataDict["symptoms"] = userData["existingSymptoms"]
            completion(dataDict)
         })
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateUserData()
     - Description: Calls method in Firestore to update database
     -------------------------------------------------------------------*/
    func updateUserData(fname: String, lname: String, age: String, email: String, password: String, phone: String, st_address1: String, st_address2: String, postal: String, province: String, city: String, country: String, symptoms: String, completion: @escaping (_ success: Bool) -> Void) {
        FBObj.updateUserData(fname: fname, lname: lname, age: age, email: email, password: password, phone: phone, st_address1: st_address1, st_address2: st_address2, postal: postal, province: province, city: city, country: country, symptoms: symptoms, completion: { success in
            completion(success)
        })
    }
}
