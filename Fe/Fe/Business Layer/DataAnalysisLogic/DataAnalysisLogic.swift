//
//  DataAnalysisLogic.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-09-08.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: DataAnalysisLogic
 - Description: Holds logic for sending data from persistence layer to
 - Firebase Clooud Functions for analysis to determine if a notification
 - needs to be sent to the user and/or emergency contact.
 -----------------------------------------------------------------------*/
class DataAnalysisLogic {
    
    // Class Variables
    let CDObj = CoreDataAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: analyzeHeartRateData()
     - Description: Pull HR data from core data and send it to Firebase
     - cloud Function to be analyzed.
     -------------------------------------------------------------------*/
    func analyzeHeartRateData() {
        print("Called Analyze HR Data")
        
        if let hrData = CDObj.fetchHeartRateDataForAnalysis() {
            // Send to cloud function
            var apiUrl = "https://us-central1-project-fe-56023.cloudfunctions.net/heartRateDataAnalysis"
        } else {
            print("Error gathering HR data for analysis")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: analyzeHeartRateData()
     - Description: Pull blood Oxygen data from core data and send it to
     - Firebase cloud Function to be analyzed.
     -------------------------------------------------------------------*/
    func analyzeBloodOxygenData() {
        print("Called Analyze Blood Ox Data")
        
        if let bloodOxygenData = CDObj.fetchBloodOxygenData() {
            // Send to cloud function
            var bloodOxCloudFunction = "https://us-central1-project-fe-56023.cloudfunctions.net/bloodOxygenDataAnalysis"
        } else {
            print("Error gathering Blood Oxygen data for analysis")
        }
    }
}
