//
//  BloodOxygenData+CoreDataProperties.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData


extension BloodOxygenData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BloodOxygenData> {
        return NSFetchRequest<BloodOxygenData>(entityName: "BloodOxygenData")
    }

    @NSManaged public var bloodOxygen: Int64
    @NSManaged public var dateTime: Date

}

extension BloodOxygenData : Identifiable {

}
