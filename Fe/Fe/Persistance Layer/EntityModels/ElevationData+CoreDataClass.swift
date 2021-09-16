//
//  ElevationData+CoreDataClass.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData

@objc(ElevationData)
public class ElevationData: NSManagedObject {

    enum CodingKeys: String, CodingKey {
        case elevation = "elevation"
        case dateTime = "dateTime"
    }
    
    //MARK: Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ElevationData", in: managedObjectContext) else {
            fatalError("Failed to decode ElevationData")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.elevation = try container.decode(Float.self, forKey: .elevation)
        self.dateTime = try container.decode(Date.self, forKey: .dateTime)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(elevation, forKey: .elevation)
        try container.encode(dateTime, forKey: .dateTime)
    }
}
