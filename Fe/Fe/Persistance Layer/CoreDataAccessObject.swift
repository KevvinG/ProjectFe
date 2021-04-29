//
//  CoreDataAccessObject.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-16.
//

// Imports
import Foundation
import CoreData
import UIKit


class CoreDataAccessObject {
    
    // CoreData config
    var healthMetricItems = [HealthMetric]()
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    init() {
        moc = appDelegate?.persistentContainer.viewContext
    }
    
//    func save(heartRate : String, appDelegate : AppDelegate?, moc: NSManagedObjectContext) {
    func save(heartRate : String) {
        let metricItem = HealthMetric(context: moc)
        metricItem.dateTime = Date()
        metricItem.altitude = 11
        metricItem.bloodOxygen = 1
        var test = Double(heartRate)
        print("testval: \(test)")
        metricItem.heartRate = Int32(test ?? 1)
        
        appDelegate?.saveContext()
        print("Saved! \(heartRate)")
    }
    
    func fetchLatestHR() -> Int {
        let hrRequest:NSFetchRequest<HealthMetric> = HealthMetric.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "dateTime", ascending: false)
        hrRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try healthMetricItems = moc.fetch(hrRequest)
        } catch {
            print("Could not load data")
        }

        if (healthMetricItems.count > 0) {
        print("Pulled value \(healthMetricItems[0].heartRate)")
        print("Pulled date \(healthMetricItems[0].dateTime!)")
        print("Pulled count \(healthMetricItems.count)")
        return Int(healthMetricItems[0].heartRate)
        } else {
            print("Empty coredata")
            return 0
        }
    }
}
