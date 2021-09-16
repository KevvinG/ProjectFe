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

        if let hrData = CDObj.fetchHeartRateDataForAnalysis(), !hrData.isEmpty {
            for item in hrData {
                print(item.heartRate)
                print(item.dateTime)
            }
            
            // Encode data to send
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted

            let jsonData = try! jsonEncoder.encode(hrData)
            let data = String(data: jsonData, encoding: String.Encoding.utf8)

            // Send to cloud function
            let apiUrl = URL(string: "https://us-central1-project-fe-56023.cloudfunctions.net/heartRateDataAnalysis")!
            
            let task = URLSession.shared.dataTask(with: apiUrl) {(data, response, error) in
                
                // Catch any errors
                guard error == nil else {
                    print("Heart Rate API error: \(String(describing: error))")
                    return
                }
                
                guard data == data else {
                    print("Error with data")
                    return
                }
                
                // Receive response back
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                print("The Response is: ", response)
            }
            task.resume()
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

        if let bloodOxygenData = CDObj.fetchBloodOxygenData(), !bloodOxygenData.isEmpty {
            
            // Encode data to send
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted

            let jsonData = try! jsonEncoder.encode(bloodOxygenData)
            let data = String(data: jsonData, encoding: String.Encoding.utf8)

            // Send to cloud function
            let apiUrl = URL(string: "https://us-central1-project-fe-56023.cloudfunctions.net/bloodOxygenDataAnalysis")!
            
            let task = URLSession.shared.dataTask(with: apiUrl) {(data, response, error) in
                
                // Catch any errors
                guard error == nil else {
                    print("Heart Rate API error: \(String(describing: error))")
                    return
                }
                
                guard data == data else {
                    print("Error with data")
                    return
                }
                
                // Receive response back
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                print("The Response is: ", response)
            }
            task.resume()
        } else {
            print("Error gathering Blood Oxygen data for analysis")
        }
    }
}
