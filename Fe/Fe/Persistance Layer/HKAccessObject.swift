//
//  HKAccessObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-08.
//

import Foundation
import HealthKit

class HKAccessObject{
    
    let healthStore = HKHealthStore()
    
    var bpmData = [Double]()
    var bpmDate = [String]()

    func fetchHealthData() -> Int {
        
        if HKHealthStore.isHealthDataAvailable() {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ])
            
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
                    interval.minute = 30
                                        
                    let endDate = Date()
                                                
                    guard let startDate = calendar.date(byAdding: .month, value: -1, to: endDate) else {
                        fatalError("*** Unable to calculate the start date ***")
                    }
                                        
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
                                let date = statistics.startDate
                                //for: E.g. for steps it's HKUnit.count()
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
//                                print("done")
//                                print(value)
//                                print(date)
                                self.bpmData.append(value)
                                //print("BPMData Appended \(value)")
                                print("BPMData Count \(self.bpmData.count)")
                                let formatter3 = DateFormatter()
                                formatter3.dateFormat = "HH:mm E, d MMM y"
//                                print(formatter3.string(from: date))
                                self.bpmDate.append(formatter3.string(from: date))
                            }
                        }
                        
                    }
                    
                    self.healthStore.execute(query)

                } else {
                    print("Authorization failed")

                }
            }

        }
        print (self.bpmData.count)
        var outInt = 0
        if bpmData.count > 0 {
            outInt = Int(bpmData[bpmData.count - 1])
        }
        print(outInt)
        return outInt
    }
    
    func returnLatestBPM() -> Int {
        return Int(bpmData[bpmData.count])
    }
    
    func getLatestHR(completion: @escaping (Double) -> Void) {
        guard let discreteHeartRate =
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            fatalError("*** Unable to create a step count type ***") }
        
        let discreteQuery = HKStatisticsQuery(quantityType: discreteHeartRate,
                                              quantitySamplePredicate: nil,
                                              options: .mostRecent) {
                                                    query, statistics, error in
            if let val = statistics?.mostRecentQuantity(){
                let hrVal = val.doubleValue(for: HKUnit(from: "count/min"))
                
                DispatchQueue.main.async {
                    completion(hrVal)
                }
            }
        }
        
        healthStore.execute(discreteQuery)

    }
}
