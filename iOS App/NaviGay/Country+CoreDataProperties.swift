//
//  Country+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var about: String?
    @NSManaged public var flag: String?
    @NSManaged public var id: Int16
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var regions: NSSet?

}

// MARK: Generated accessors for regions
extension Country {

    @objc(addRegionsObject:)
    @NSManaged public func addToRegions(_ value: Region)

    @objc(removeRegionsObject:)
    @NSManaged public func removeFromRegions(_ value: Region)

    @objc(addRegions:)
    @NSManaged public func addToRegions(_ values: NSSet)

    @objc(removeRegions:)
    @NSManaged public func removeFromRegions(_ values: NSSet)

}

extension Country : Identifiable {

}
