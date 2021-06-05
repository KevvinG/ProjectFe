//
//  ElevationData+CoreDataProperties.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

import Foundation
import CoreData


extension ElevationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ElevationData> {
        return NSFetchRequest<ElevationData>(entityName: "ElevationData")
    }

    @NSManaged public var dateTime: Date
    @NSManaged public var elevation: Float

}

extension ElevationData : Identifiable {

}
