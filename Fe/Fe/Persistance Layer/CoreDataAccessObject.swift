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
        return self.hrItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHeartRateDataWithRange()
     - Description: Fetch for charts.
     -------------------------------------------------------------------*/
    func fetchHeartRateDataWithRange(dateRange: String) -> [HeartRateData]? {
        let yesterday = Date().addingTimeInterval(-86400)
        let fetchPredicate = NSPredicate(format: "dateTime > %@", yesterday as NSDate, #keyPath(HeartRateData.dateTime))
        
        var request = NSFetchRequest<HeartRateData>(entityName: "HeartRateData")
        request.predicate = fetchPredicate
        
        do {
            self.hrItems = try context.fetch(request)
        } catch let error as NSError {
            print("Heart Rate Data read failed: \(error.description)")
        }
        return self.hrItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupTempValues()
     - Description: Sets up testing data for when the device is unavailable.
     -------------------------------------------------------------------*/
    func setupTempValues() {
        self.deleteAllHREntries()
        var timeOffset = -18000
        var initBPM = 58
        var i = 0
        while i<5 {
            let newHRentry = HeartRateData(context: self.context)
            newHRentry.dateTime = Date().addingTimeInterval(Double(timeOffset))
            newHRentry.heartRate = Int64(initBPM)
            saveContext(tableName: "HeartRateData")
            initBPM = initBPM + 2
            timeOffset = timeOffset + 3600
            i+=1
        }
        let newHRentry = HeartRateData(context: self.context)
        newHRentry.dateTime = Date()
        newHRentry.heartRate = Int64(61)
        saveContext(tableName: "HeartRateData")

        self.deleteAllBloodOxygenEntries()
        timeOffset = -18000
        var initO2 = 99
        i = 0
        while i<5 {
            let newO2entry = BloodOxygenData(context: self.context)
            newO2entry.bloodOxygen = Int64(initO2)
            newO2entry.dateTime = Date().addingTimeInterval(Double(timeOffset))
            saveContext(tableName: "BloodOxygenData")
            initO2 = initO2 - 1
            timeOffset = timeOffset + 3600
            i+=1
        }
        let newO2entry = BloodOxygenData(context: self.context)
        newO2entry.dateTime = Date()
        newO2entry.bloodOxygen = Int64(98)
        saveContext(tableName: "BloodOxygenData")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeartRateData")
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
    func fetchBloodOxygenDataWithRange(dateRange: String) -> [BloodOxygenData]? {
        let yesterday = Date().addingTimeInterval(-89400)
        let fetchPredicate = NSPredicate(format: "dateTime > %@", yesterday as NSDate, #keyPath(BloodOxygenData.dateTime))
        
        var request = NSFetchRequest<BloodOxygenData>(entityName: "BloodOxygenData")
        request.predicate = fetchPredicate
        
        do {
            self.bldOxItems = try context.fetch(request)
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BloodOxygenData")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ElevationData")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirPressureData")
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
    
    /*--------------------------------------------------------------------
     //MARK: getHrChartData()
     - Description: New functino for HR chart.
     -------------------------------------------------------------------*/
    func getHrChartData(dateRange: String, completion: @escaping (_ bpmDict: [String:Double]) -> Void) {
        var bpmDict: [String:Double] = [:]
            
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
    }
}
