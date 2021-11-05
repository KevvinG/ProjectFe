//
//  CoreDataAccessObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-16.
//

// MARK: Imports
import Foundation
import CoreData
import UIKit

/*------------------------------------------------------------------------
 //MARK: CoreDataAccessObject
 - Description: Access Core Data
 -----------------------------------------------------------------------*/
class CoreDataAccessObject {
    
    // Class Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var apItems: [AirPressureData] = []
    var eleItems: [ElevationData] = []
    var hrItems: [HeartRateData] = []
    var hrAnalysisItems: [HeartRateData] = []
    var bldOxItems: [BloodOxygenData] = []
    
    /*--------------------------------------------------------------------
     //MARK: createHeartRateTableEntry()
     - Description: create Table Entry for Heart Rate.
     -------------------------------------------------------------------*/
    func createHeartRateTableEntry(hrValue: String) {
        let hrFloat = Float(hrValue) ?? -1 // receive a float value
        let hr = Int(hrFloat) // convert for table.
        if hr != -1 {
            let newHRentry = HeartRateData(context: self.context)
            newHRentry.dateTime = Date()
            newHRentry.heartRate = Int64(hr)
            saveContext(tableName: "HeartRateData")
        } else {
            print("Error converting HR value. Did not create new table entry.")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHeartRateData()
     - Description: Fetch Heart Rate from table (only today's data).
     -------------------------------------------------------------------*/
    func fetchHeartRateData() -> [HeartRateData]?{
        do {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            //Filtering for today is not working, needs to be reworked
//            self.hrItems = try context.fetch(HeartRateData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) > dateFormatter.string(from: today) } )
            self.hrItems = try context.fetch(HeartRateData.fetchRequest())
        } catch let error as NSError {
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        print(self.hrItems)
        return self.hrItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHeartRateDataWithRange()
     - Description:
     -------------------------------------------------------------------*/
    func fetchHeartRateDataWithRange(dateRange: String) {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(HeartRateData.dateTime))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(HeartRateData.dateTime), dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
//        fetchRequest.predicate = datePredicate
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHeartRateDataForAnalysis()
     - Description: Fetch Heart Rate for last 5 minutes.
     -------------------------------------------------------------------*/
    func fetchHeartRateDataForAnalysis() -> [HeartRateData]?{
        do {
            let previousTime = Calendar.current.date(byAdding: .minute, value: -5, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let fetchRequest:NSFetchRequest<HeartRateData> = HeartRateData.fetchRequest()
            fetchRequest.fetchLimit = 300
            
            self.hrAnalysisItems = try context.fetch(fetchRequest).filter( {
                dateFormatter.string(from: $0.dateTime) > dateFormatter.string(from: previousTime)
            })
        } catch let error as NSError{
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        return self.hrAnalysisItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestHR()
     - Description: Fetch latest saved heart rate entry from table.
     -------------------------------------------------------------------*/
    func fetchLatestHR() -> Int {
        do {
            self.hrItems = try context.fetch(HeartRateData.fetchRequest())
        } catch let error as NSError{
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        if hrItems.count > 0 {
            let topItem = hrItems.sorted(by: { $0.dateTime > $1.dateTime })
            return Int(topItem[0].heartRate)
        } else {
            print("Empty HR table")
            return -1
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAllHREntries()
     - Description: Delete all HR Entries from Core Data
     -------------------------------------------------------------------*/
    func deleteAllHREntries() -> Bool {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeartRateData")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(batchDeleteRequest)
            saveContext(tableName: "HeartRateData")
            return true
        } catch {
            print("Error deleting data from HeartRateData Table")
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestSPO2()
     - Description: Fetch latest saved Blood Ox entry from table.
     -------------------------------------------------------------------*/
    func fetchLatestSPO2() -> Int {
        do {
            self.bldOxItems = try context.fetch(BloodOxygenData.fetchRequest())
        } catch let error as NSError{
            print("Blood Oxygen Data Read Fetch Failed: \(error.description)")
        }
        if bldOxItems.count > 0 {
            let topItem = bldOxItems.sorted(by: { $0.dateTime > $1.dateTime })
            return Int(topItem[0].bloodOxygen)
        } else {
            print("Empty SPO2 table")
            return -1
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: createBloodOxygenTableEntry()
     - Description: Create Table Entry for Blood Oxygen.
     -------------------------------------------------------------------*/
    func createBloodOxygenTableEntry(bloodOxValue: Int) {
        let newBloodOxEntry = BloodOxygenData(context: self.context)
        newBloodOxEntry.dateTime = Date()
        newBloodOxEntry.bloodOxygen = Int64(bloodOxValue)
        saveContext(tableName: "BloodOxygenData")
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchBloodOxygenData()
     - Description: Fetch Blood Oxygen from table (only today's data).
     -------------------------------------------------------------------*/
    func fetchBloodOxygenData() -> [BloodOxygenData]? {
        do {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            //Filtering for today is not working, needs to be reworked
            self.bldOxItems = try context.fetch(BloodOxygenData.fetchRequest())
//            self.bldOxItems = try context.fetch(BloodOxygenData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) == dateFormatter.string(from: today) } )
        } catch let error as NSError{
            print("BloodOxygenData Read Fetch Failed: \(error.description)")
        }
        return self.bldOxItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchbloodOxygenDataForAnalysis()
     - Description: Fetch blood Ox data for last 5 minutes.
     -------------------------------------------------------------------*/
    func fetchbloodOxygenDataForAnalysis() -> [BloodOxygenData]?{
        do {
            let previousTime = Calendar.current.date(byAdding: .minute, value: -5, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            
            let fetchRequest:NSFetchRequest<BloodOxygenData> = BloodOxygenData.fetchRequest()
            fetchRequest.fetchLimit = 300
            
            self.bldOxItems = try context.fetch(fetchRequest).filter( {
                dateFormatter.string(from: $0.dateTime) > dateFormatter.string(from: previousTime)
            } )
        } catch let error as NSError{
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        return self.bldOxItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAllBloodOxygenEntries()
     - Description: Delete all Blood Oxygen Entries from Core Data
     -------------------------------------------------------------------*/
    func deleteAllBloodOxygenEntries() -> Bool {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BloodOxygenData")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(batchDeleteRequest)
            saveContext(tableName: "BloodOxygenData")
            return true
        } catch {
            print("Error deleting data from BloodOxygenData Table")
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: createElevationDataTableEntry()
     - Description: Create Table Entry for Elevation.
     -------------------------------------------------------------------*/
    func createElevationDataTableEntry(eleValue: Float) {
        let newEleEntry = ElevationData(context: self.context)
        newEleEntry.dateTime = Date()
        newEleEntry.elevation = Float(eleValue)
        saveContext(tableName: "ElevationData")
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestElevation()
     - Description: Fetch latest saved elevation entry from table.
     -------------------------------------------------------------------*/
    func fetchLatestElevation() -> Float {
        do {
            self.eleItems = try context.fetch(ElevationData.fetchRequest())
        } catch let error as NSError{
            print("ElevationData Read Fetch Failed: \(error.description)")
        }
        if eleItems.count > 0 {
            let topItem = eleItems.sorted(by: { $0.dateTime > $1.dateTime })
            return Float(topItem[0].elevation)
        } else {
            print("Empty Elevation table")
            return -1.00
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchElevationData()
     - Description: Fetch Elevation from table (only today's data).
     -------------------------------------------------------------------*/
    func fetchElevationData() -> [ElevationData]?{
        do {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            self.eleItems = try context.fetch(ElevationData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) == dateFormatter.string(from: today) } )
        } catch let error as NSError{
            print("ElevationData Read Fetch Failed: \(error.description)")
        }
        return self.eleItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAllElevationEntries()
     - Description: Delete all Elevation Entries from Core Data
     -------------------------------------------------------------------*/
    func deleteAllElevationEntries() -> Bool {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ElevationData")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(batchDeleteRequest)
            saveContext(tableName: "ElevationData")
            return true
        } catch {
            print("Error deleting data from ElevationData Table")
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: createAirPressureDataTableEntry()
     - Description: Create Table Entry for Air Pressure.
     -------------------------------------------------------------------*/
    func createAirPressureDataTableEntry(apValue: Float) {
        let newAPentry = AirPressureData(context: self.context)
        newAPentry.dateTime = Date()
        newAPentry.airPressure = Float(apValue)
        saveContext(tableName: "AirPressureData")
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchLatestAirPressure()
     - Description: Fetch latest saved air pressure entry from table.
     -------------------------------------------------------------------*/
    func fetchLatestAirPressure() -> Float {
        do {
            self.apItems = try context.fetch(AirPressureData.fetchRequest())
        } catch let error as NSError{
            print("AirPressureData Read Fetch Failed: \(error.description)")
        }
        if apItems.count > 0 {
            let topItem = apItems.sorted(by: { $0.dateTime > $1.dateTime })
            return Float(topItem[0].airPressure)
        } else {
            print("Empty Air Pressure table")
            return -1.00
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchAirPressureData()
     - Description: Fetch Air Pressure from table (only today's data).
     -------------------------------------------------------------------*/
    func fetchAirPressureData() -> [AirPressureData]? {
        do {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            self.apItems = try context.fetch(AirPressureData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) == dateFormatter.string(from: today) } )
        } catch let error as NSError{
             print("AirPressureData Read Fetch Failed: \(error.description)")
        }
        return self.apItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: updateAirPressureDataTableEntry()
     - Description: Update Air Pressure entry from table.
     -------------------------------------------------------------------*/
    func updateAirPressureDataTableEntry(date: Date, apValue: Float, index: Int) {
        // Search for the entry in the table
        let apEntryToUpdate = self.apItems[index]
        apEntryToUpdate.dateTime = date
        apEntryToUpdate.airPressure = Float(apValue)
        saveContext(tableName: "AirPressureData")
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAirPressureDataTableEntry()
     - Description: Delete Air Pressure entry from table.
     -------------------------------------------------------------------*/
    func deleteAirPressureDataTableEntry(index: Int) {
        // Search for the entry in the table
        let apEntryToDelete = self.apItems[index]
        self.context.delete(apEntryToDelete)
        saveContext(tableName: "AirPressureData")
    }
    
    /*--------------------------------------------------------------------
     //MARK: deleteAllairPressureEntries()
     - Description: Delete all Air Pressure Entries from Core Data
     -------------------------------------------------------------------*/
    func deleteAllairPressureEntries() -> Bool {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirPressureData")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.context.execute(batchDeleteRequest)
            saveContext(tableName: "AirPressureData")
            return true
        } catch {
            print("Error deleting data from AirPressureData Table")
            return false
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: saveContext()
     - Description: Save table changes.
     -------------------------------------------------------------------*/
    func saveContext(tableName: String) {
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Error saving the new data entry to \(tableName) Table: \(error.description)")
        }
    }
}
