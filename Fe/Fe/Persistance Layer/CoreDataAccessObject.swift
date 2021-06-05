//
//  CoreDataAccessObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-16.
//

// MARK: - Imports
import Foundation
import CoreData
import UIKit

/*------------------------------------------------------------------------
 - Class: CoreDataAccessObject
 - Description:
 -----------------------------------------------------------------------*/
class CoreDataAccessObject {
    
    // Class Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var apItems:[AirPressureData] = []
    var eleItems:[ElevationData] = []
    var hrItems:[HeartRateData] = []
    var bldOxItems:[BloodOxygenData] = []
    
    // MARK: - Create HR Table Item
    func createHeartRateTableEntry(hrValue: Int) {
        let newHRentry = HeartRateData(context: self.context)
        newHRentry.dateTime = Date()
        newHRentry.heartRate = Int64(hrValue)
        saveContext(tableName: "HeartRateData")
//        print("Saved HR: \(newHRentry.heartRate)")
    }
    
    // MARK: - Fetch HR From Table
    func fetchHeartRateData() -> [HeartRateData]?{
        do {
            self.hrItems = try context.fetch(HeartRateData.fetchRequest())
        } catch let error as NSError{
            print("HeartRateData Read Fetch Failed: \(error.description)")
        }
        return self.hrItems
    }
    
    // MARK: - Create Blood Ox Table Item
    func createBloodOxygenTableEntry(bloodOxValue: Int) {
        let newBloodOxEntry = BloodOxygenData(context: self.context)
        newBloodOxEntry.dateTime = Date()
        newBloodOxEntry.bloodOxygen = Int64(bloodOxValue)
        saveContext(tableName: "BloodOxygenData")
//        print("Saved Blood Ox: \(newBloodOxEntry.bloodOxygen)")
    }
    
    // MARK: - Fetch Blood Ox From Table
    func fetchBloodOxygenData() -> [BloodOxygenData]? {
        do {
            self.bldOxItems = try context.fetch(BloodOxygenData.fetchRequest())
        } catch let error as NSError{
            print("BloodOxygenData Read Fetch Failed: \(error.description)")
        }
        return self.bldOxItems
    }
    
    // MARK: - Create Elevation Table Item
    func createElevationDataTableEntry(eleValue: Float) {
        let newEleEntry = ElevationData(context: self.context)
        newEleEntry.dateTime = Date()
        newEleEntry.elevation = Float(eleValue)
        saveContext(tableName: "ElevationData")
//        print("Saved Elevation: \(newEleEntry.elevation)")
    }
    
    // MARK: - Fetch Elevation From Table
    func fetchElevationData() -> [ElevationData]?{
        do {
            self.eleItems = try context.fetch(ElevationData.fetchRequest())
        } catch let error as NSError{
            print("ElevationData Read Fetch Failed: \(error.description)")
        }
        return self.eleItems
    }
    
    // MARK: - Create Air Pressure Table Item
    func createAirPressureDataTableEntry(apValue: Float) {
        let newAPentry = AirPressureData(context: self.context)
        newAPentry.dateTime = Date()
        newAPentry.airPressure = Float(apValue)
        saveContext(tableName: "AirPressureData")
//        print("Saved Air Pressure: \(newAPentry.airPressure)")
    }
    
    // MARK: - Fetches Air Pressure From Table
    func fetchAirPressureData() -> [AirPressureData]? {
        do {
            self.apItems = try context.fetch(AirPressureData.fetchRequest())
        } catch let error as NSError{
            print("AirPressureData Read Fetch Failed: \(error.description)")
        }
        return self.apItems
    }
    
    // MARK: - Delete Air Pressure Table Item
    func deleteAirPressureDataTableEntry(index: Int) {
        // Search for the entry in the table
        let apEntryToDelete = self.apItems[index]
        self.context.delete(apEntryToDelete)
        saveContext(tableName: "AirPressureData")
    }
    
    // MARK: - Update Air Rressure Table Item
    func updateAirPressureDataTableEntry(date: Date, apValue: Float, index: Int) {
        // Search for the entry in the table
        let apEntryToUpdate = self.apItems[index]
        apEntryToUpdate.dateTime = date
        apEntryToUpdate.airPressure = Float(apValue)
        saveContext(tableName: "AirPressureData")
    }
    
    // MARK: - Save Context Core Data
    func saveContext(tableName: String) {
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Error saving the new data entry to \(tableName) Table: \(error.description)")
        }
    }
}
