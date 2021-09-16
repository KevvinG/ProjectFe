//
//  HeartRateData+CoreDataProperties.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData


extension HeartRateData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeartRateData> {
        return NSFetchRequest<HeartRateData>(entityName: "HeartRateData")
    }

    @NSManaged public var dateTime: Date
    @NSManaged public var heartRate: Int64

}

extension HeartRateData : Identifiable {

}
