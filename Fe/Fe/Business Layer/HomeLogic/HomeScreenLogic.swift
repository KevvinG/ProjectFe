//
//  HomeScreenLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: HomeScreenLogic
 - Description: Holds logic for the Home Screen
 -----------------------------------------------------------------------*/
class HomeScreenLogic {
    
    // Class Variables
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: homeScreenSetup()
     - Description: Set up home screen options once logged in.
     -------------------------------------------------------------------*/
    func homeScreenSetup() {
    }
    
    /*--------------------------------------------------------------------
     //MARK: checkIfNewUser()
     - Description: Checks Firebase if the user logging in is new.
     -------------------------------------------------------------------*/
    func checkIfNewUser(completion: @escaping (_ isNewUser: Bool) -> Void) {
        FBObj.checkIfNewUser(completion: { isNewUser in
            completion(isNewUser)
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: getUserHrThresholds()
     - Description: Calls Firebase method and displays data in
     - each of the appropriate TextViews.
     -------------------------------------------------------------------*/
    func getUserHrThresholds(completion: @escaping (_ dataDict: Dictionary<String,String>) -> Void) {
        FBObj.getUserHrThresholds(completion: { thresholds in
            completion(thresholds)
         })
    }
}
