//
//  HKAccessObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-08.
//

// Imports
import Foundation
import HealthKit

/*------------------------------------------------------------------------
 - Class: HKAccessObject
 - Description: Holds methods for accessing HealtthKit Data
 -----------------------------------------------------------------------*/
class HKAccessObject {
    // Class Variables
    let healthStore = HKHealthStore()

    /*--------------------------------------------------------------------
     - Function: fetchHealthData()
     - Description:
     -------------------------------------------------------------------*/
    func fetchHRData(dateRange: String, completion: @escaping (_ bpmDict: [String:Double]) -> Void) {
        var bpmDict : [String:Double] = [:]
        
        // Check if Health Data is available
        if HKHealthStore.isHealthDataAvailable() {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ])
            
            // Ask for authorization to read data
            healthStore.requestAuthorization(toShare: [], read: readData) { (success, error) in
                if success {
                    let calendar = NSCalendar.current
                    var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                    let offset = (7 + anchorComponents.weekday! - 2) % 7
                    
                    anchorComponents.day! -= offset
                    anchorComponents.hour = 2
                    
                    guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                        fatalError("*** unable to create a valid date from the given components ***")
                    }
                    
                    let interval = NSDateComponents()
                    switch dateRange {
                    
                    case "day":
                        interval.minute = 1
                    
                    default:
                        interval.minute = 30
                    }
                    
                                        
                    let endDate = Date()
                    
                    guard var startDate = calendar.date(byAdding: .month, value: -1, to: endDate) else {
                        fatalError("*** Unable to calculate the start date ***")
                    }
                    
                    switch dateRange {
                    
                    case "month":
                        startDate = calendar.date(byAdding: .month, value: -1, to: endDate) ?? Date()
                        break
                    case "day":
                        startDate = calendar.date(byAdding: .day, value: -1, to: endDate) ?? Date()
                        break
                        
                    default:
                        print("No DR Selected, default to month")
                        startDate = calendar.date(byAdding: .month, value: -1, to: endDate) ?? Date()
                    }
//                    guard let startDate = calendar.date(byAdding: DR, value: -1, to: endDate) else {
//                        fatalError("*** Unable to calculate the start date ***")
//                    }
                                        
                    guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                        fatalError("*** Unable to create a step count type ***")
                    }

                    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                            quantitySamplePredicate: nil,
                                                                options: .discreteAverage,
                                                                anchorDate: anchorDate,
                                                                intervalComponents: interval as DateComponents)
                    query.initialResultsHandler = {
                        query, results, error in
                        
                        guard let statsCollection = results else {
                            fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                        }
                                            
                        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                            if let quantity = statistics.averageQuantity() {
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                let date = statistics.startDate
                                let formatter3 = DateFormatter()
                                formatter3.dateFormat = "HH:mm E, d MMM y"
                                bpmDict[formatter3.string(from: date)] = value
                            }
                        }
                        completion(bpmDict)
                    }
                    self.healthStore.execute(query)
                    
                } else {
                    print("Authorization failed")
                }
            }
        } else {
            print("Healthkit not available.")
        }
    }
    
    func fetchO2Data(dateRange: String, completion: @escaping (_ o2Dict: [String:Double]) -> Void) {
        var o2Dict : [String:Double] = [:]
        
        // Check if Health Data is available
        if HKHealthStore.isHealthDataAvailable() {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
            ])
            
            // Ask for authorization to read data
            healthStore.requestAuthorization(toShare: [], read: readData) { (success, error) in
                if success {
                    let calendar = NSCalendar.current
                    var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                    let offset = (7 + anchorComponents.weekday! - 2) % 7
                    
                    anchorComponents.day! -= offset
                    anchorComponents.hour = 2
                    
                    guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                        fatalError("*** unable to create a valid date from the given components ***")
                    }
                    
                    let interval = NSDateComponents()
                    switch dateRange {
                    
                    case "day":
                        interval.minute = 1
                    
                    default:
                        interval.minute = 30
                    }
                    
                                        
                    let endDate = Date()
                    
                    guard var startDate = calendar.date(byAdding: .month, value: -1, to: endDate) else {
                        fatalError("*** Unable to calculate the start date ***")
                    }
                    
                    switch dateRange {
                    
                    case "month":
                        startDate = calendar.date(byAdding: .month, value: -1, to: endDate) ?? Date()
                        break
                    case "day":
                        startDate = calendar.date(byAdding: .day, value: -1, to: endDate) ?? Date()
                        break
                        
                    default:
                        print("No DR Selected, default to month")
                        startDate = calendar.date(byAdding: .month, value: -1, to: endDate) ?? Date()
                    }
//                    guard let startDate = calendar.date(byAdding: DR, value: -1, to: endDate) else {
//                        fatalError("*** Unable to calculate the start date ***")
//                    }
                                        
                    guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation) else {
                        fatalError("*** Unable to create a o2 Type ***")
                    }

                    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                            quantitySamplePredicate: nil,
                                                                options: .discreteAverage,
                                                                anchorDate: anchorDate,
                                                                intervalComponents: interval as DateComponents)
                    query.initialResultsHandler = {
                        query, results, error in
                        
                        guard let statsCollection = results else {
                            fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                        }
                                            
                        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                            if let quantity = statistics.averageQuantity() {
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                let date = statistics.startDate
                                let formatter3 = DateFormatter()
                                formatter3.dateFormat = "HH:mm E, d MMM y"
                                o2Dict[formatter3.string(from: date)] = value
                            }
                        }
                        completion(o2Dict)
                    }
                    self.healthStore.execute(query)
                    
                } else {
                    print("Authorization failed")
                }
            }
        } else {
            print("Healthkit not available.")
        }
    }
    /*--------------------------------------------------------------------
     - Function: getLatestHR()
     - Description: returns latest Heart Rate Number
     -------------------------------------------------------------------*/
    func getLatestHR(completion: @escaping (_ hrVal: Int) -> Void) {
        guard let discreteHeartRate = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let discreteQuery = HKStatisticsQuery(quantityType: discreteHeartRate, quantitySamplePredicate: nil, options: .mostRecent) { query, statistics, error in
            if let val = statistics?.mostRecentQuantity(){
                let hrVal = Int(val.doubleValue(for: HKUnit(from: "count/min")))
                
                DispatchQueue.main.async {
                    completion(hrVal)
                }
            }
        }
        healthStore.execute(discreteQuery)
    }
    
    func getLatestO2(completion: @escaping (Double) -> Void) {
        print("Oxy func called")
        
        guard let discreteOxySat = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation) else {
            fatalError("*** Unable to create O2 Type ***")
        }
        
        let discreteQuery = HKStatisticsQuery(quantityType: discreteOxySat,
                                              quantitySamplePredicate: nil,
                                              options: .mostRecent) {
                                                    query, statistics, error in
            if let val = statistics?.mostRecentQuantity(){
                let oxyVal = val.doubleValue(for: HKUnit(from: "percent"))
                
                DispatchQueue.main.async {
                    completion(oxyVal)
                }
            }
        }
        healthStore.execute(discreteQuery)
    }
}
