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
    var bldOxItems: [BloodOxygenData] = []
    
    /*--------------------------------------------------------------------
     //MARK: createHeartRateTableEntry()
     - Description: create Table Entry for Heart Rate.
     -------------------------------------------------------------------*/
    func createHeartRateTableEntry(hrValue: String) {
        let hrFloat = Float(hrValue) ?? 0 // receive a float value
        let hr = Int(hrFloat) // convert for table.
        if hr != 0 {
            let newHRentry = HeartRateData(context: self.context)
            newHRentry.dateTime = Date()
            newHRentry.heartRate = Int64(hr)
            saveContext(tableName: "HeartRateData")
        } else {
            print("Error converting HR value. Did not create new table entry.")
        }
//        print("Saved HR: \(newHRentry.heartRate)")
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
            self.hrItems = try context.fetch(HeartRateData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) > dateFormatter.string(from: today) } )
        } catch let error as NSError {
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        return self.hrItems
    }
    
    /*--------------------------------------------------------------------
     //MARK: fetchHeartRateDataForAnalysis()
     - Description: Fetch Heart Rate for last 5 minutes.
     -------------------------------------------------------------------*/
    func fetchHeartRateDataForAnalysis() -> [HeartRateData]?{
        do {
            let previousTime = Calendar.current.date(byAdding: .minute, value: -5, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm.dd"
            
            let fetchRequest:NSFetchRequest<HeartRateData> = HeartRateData.fetchRequest()
            fetchRequest.fetchLimit = 300
            
            self.hrItems = try context.fetch(fetchRequest).filter( {
                dateFormatter.string(from: $0.dateTime) > dateFormatter.string(from: previousTime)
            } )
        } catch let error as NSError{
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        return self.hrItems
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
            return 0
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
//        print("Saved Blood Ox: \(newBloodOxEntry.bloodOxygen)")
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
            self.bldOxItems = try context.fetch(BloodOxygenData.fetchRequest()).filter( { dateFormatter.string(from: $0.dateTime) == dateFormatter.string(from: today) } )
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
     //MARK: createElevationDataTableEntry()
     - Description: Create Table Entry for Elevation.
     -------------------------------------------------------------------*/
    func createElevationDataTableEntry(eleValue: Float) {
        let newEleEntry = ElevationData(context: self.context)
        newEleEntry.dateTime = Date()
        newEleEntry.elevation = Float(eleValue)
        saveContext(tableName: "ElevationData")
//        print("Saved Elevation: \(newEleEntry.elevation)")
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
     //MARK: createAirPressureDataTableEntry()
     - Description: Create Table Entry for Air Pressure.
     -------------------------------------------------------------------*/
    func createAirPressureDataTableEntry(apValue: Float) {
        let newAPentry = AirPressureData(context: self.context)
        newAPentry.dateTime = Date()
        newAPentry.airPressure = Float(apValue)
        saveContext(tableName: "AirPressureData")
//        print("Saved Air Pressure: \(newAPentry.airPressure)")
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
