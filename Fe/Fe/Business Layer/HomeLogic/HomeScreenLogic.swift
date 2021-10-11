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
    let HKObj = HKAccessObject()
    let FBObj = FirebaseAccessObject()
    let CDObj = CoreDataAccessObject()
    let phoneObj = PhoneSensorObject()
    let DALogic = DataAnalysisLogic()
    let HRObj = HeartRateLogic()
    let BldOxObj = BloodOxygenLogic()
    let AltObj = AltitudeLogic()
    
    /*--------------------------------------------------------------------
     //MARK: homeScreenSetup()
     - Description: Set up home screen options once logged in.
     -------------------------------------------------------------------*/
    func homeScreenSetup() {
        FBObj.checkIfNewUser() // Check if user already exists and add new user if not.
    }
}
