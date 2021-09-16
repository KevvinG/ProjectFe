//
//  HeartRateData+CoreDataClass.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData

@objc(HeartRateData)
public class HeartRateData: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case heartRate = "heartRate"
        case dateTime = "dateTime"
    }
    
    //MARK: Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "HeartRateData", in: managedObjectContext) else {
            fatalError("Failed to decode HeartRateData")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.heartRate = try container.decode(Int64.self, forKey: .heartRate)
        self.dateTime = try container.decode(Date.self, forKey: .dateTime)
    }

    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(heartRate, forKey: .heartRate)
        try container.encode(dateTime, forKey: .dateTime)
    }
}
