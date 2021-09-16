//
//  BloodOxygenData+CoreDataClass.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-03.
//
//

//MARK: Imports
import Foundation
import CoreData

@objc(BloodOxygenData)
public class BloodOxygenData: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case bloodOxygen = "bloodOxygen"
        case dateTime = "dateTime"
    }
    
    //MARK: Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "BloodOxygenData", in: managedObjectContext) else {
            fatalError("Failed to decode BloodOxygenData")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bloodOxygen = try container.decode(Int64.self, forKey: .bloodOxygen)
        self.dateTime = try container.decode(Date.self, forKey: .dateTime)
    }

    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bloodOxygen, forKey: .bloodOxygen)
        try container.encode(dateTime, forKey: .dateTime)
    }
}
