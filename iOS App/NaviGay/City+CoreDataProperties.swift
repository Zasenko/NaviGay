//
//  City+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var about: String?
    @NSManaged public var id: Int16
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var places: NSSet?
    @NSManaged public var region: Region?

}

// MARK: Generated accessors for places
extension City {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension City : Identifiable {

}
