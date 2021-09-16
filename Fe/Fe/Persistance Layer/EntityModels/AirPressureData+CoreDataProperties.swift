//
//  AirPressureData+CoreDataProperties.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData


extension AirPressureData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirPressureData> {
        return NSFetchRequest<AirPressureData>(entityName: "AirPressureData")
    }

    @NSManaged public var airPressure: Float
    @NSManaged public var dateTime: Date

}

extension AirPressureData : Identifiable {

}
