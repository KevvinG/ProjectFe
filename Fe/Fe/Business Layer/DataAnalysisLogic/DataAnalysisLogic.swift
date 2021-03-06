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
    let FBObj = FirebaseAccessObject()
    
    /*--------------------------------------------------------------------
     //MARK: analyzeHeartRateData()
     - Description: Pull HR data from core data and send it to Firebase
     - cloud Function to be analyzed.
     -------------------------------------------------------------------*/
    func analyzeHeartRateData() {

        FBObj.getUserdataForAnalysis(completion: { userData in
            // URL Variables
            let fName = userData["fName"]!
            let fcmToken = userData["fcmToken"]!
            let emergencyPhone = userData["emergencyPhone"]!
            let hrLowThreshold = userData["hrLowThreshold"]!
            let hrHighThreshold = userData["hrHighThreshold"]!
            let emergencySwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotifyEmergencyContactKey.description)
            var emergencySwitch = "false"
            if emergencySwitchState != nil {
                emergencySwitch = String(emergencySwitchState!)
            }
            
            if let hrData = self.CDObj.fetchHeartRateDataForAnalysis(), !hrData.isEmpty {
                
                // Encode data to send
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try! encoder.encode(hrData)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                // Verify string is not null before proceeding
                if jsonString != nil {
                    
                    // Create url string dynamically
                    var components = URLComponents()
                    components.scheme = "https"
                    components.host = "us-central1-project-fe-56023.cloudfunctions.net"
                    components.path = "/heartRateDataAnalysis"
                    components.queryItems = [
                        URLQueryItem(name: "fName", value: fName),
                        URLQueryItem(name: "fcmToken", value: fcmToken),
                        URLQueryItem(name: "emergencyPhone", value: emergencyPhone),
                        URLQueryItem(name: "emergencySwitch", value: emergencySwitch),
                        URLQueryItem(name: "hrLowThreshold", value: hrLowThreshold),
                        URLQueryItem(name: "hrHighThreshold", value: hrHighThreshold),
                        URLQueryItem(name: "data", value: jsonString),
                    ]
                    let url = components.url?.absoluteString
                    
                    // Send to cloud function
                    guard let apiUrl = URL(string: url!) else {
                        print("Invalid heartRate URL")
                        return
                    }
                    
                    let request = URLRequest(url: apiUrl)
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        
                        // Catch any errors
                        guard error == nil else {
                            print("Heart Rate API error: \(String(describing: error))")
                            return
                        }
                        
                        // Receive response back
                        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("HR call Server error!")
                            return
                        }
                        //print("HR API response: \(response)")
                    }.resume()
                }
            } else {
                print("Error gathering HR data for analysis")
            }
        })
    }
    
    /*--------------------------------------------------------------------
     //MARK: analyzeHeartRateData()
     - Description: Pull blood Oxygen data from core data and send it to
     - Firebase cloud Function to be analyzed.
     -------------------------------------------------------------------*/
    func analyzeBloodOxygenData() {
        
        FBObj.getUserdataForAnalysis(completion: { userData in
            // URL Variables
            let fName = userData["fName"]!
            let fcmToken = userData["fcmToken"]!
            let emergencyPhone = userData["emergencyPhone"]!
            let hrLowThreshold = userData["hrLowThreshold"]!
            let hrHighThreshold = userData["hrHighThreshold"]!
            let emergencySwitchState = UserDefaults.standard.getSwitchState(key: UserDefaultKeys.swNotifyEmergencyContactKey.description)
            var emergencySwitch = "false"
            if emergencySwitchState != nil {
                emergencySwitch = String(emergencySwitchState!)
            }
            
            if let bloodOxygenData = self.CDObj.fetchBloodOxygenDataWithRange(dateRange: "day"), !bloodOxygenData.isEmpty {
            
                // Encode data to send
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try! encoder.encode(bloodOxygenData)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                // Verify string is not null before proceeding
                if jsonString != nil {
                    
                    // Create url string dynamically
                    var components = URLComponents()
                    components.scheme = "https"
                    components.host = "us-central1-project-fe-56023.cloudfunctions.net"
                    components.path = "/heartRateDataAnalysis"
                    components.queryItems = [
                        URLQueryItem(name: "fName", value: fName),
                        URLQueryItem(name: "fcmToken", value: fcmToken),
                        URLQueryItem(name: "emergencyPhone", value: emergencyPhone),
                        URLQueryItem(name: "emergencySwitch", value: emergencySwitch),
                        URLQueryItem(name: "hrLowThreshold", value: hrLowThreshold),
                        URLQueryItem(name: "hrHighThreshold", value: hrHighThreshold),
                        URLQueryItem(name: "data", value: jsonString),
                    ]
                    let url = components.url?.absoluteString
                    
                    // Send to cloud function
                    guard let apiUrl = URL(string: url!) else {
                        print("Invalid Blood Oxygen URL")
                        return
                    }
                    
                    let request = URLRequest(url: apiUrl)
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        
                        // Catch any errors
                        guard error == nil else {
                            print("Blood Oxygen API error: \(String(describing: error))")
                            return
                        }
                        
                        // Receive response back
                        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("Bld Ox Call Server error!")
                            return
                        }
                        //print("Bld Ox API response: \(response)")
                    }.resume()
                }
            } else {
                print("Error gathering Blood Oxygen data for analysis")
            }
        })
    }
}
