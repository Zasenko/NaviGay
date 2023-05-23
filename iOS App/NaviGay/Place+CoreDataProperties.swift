//
//  Place+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var id: Int64
    @NSManaged public var isActive: Bool
    @NSManaged public var isChecked: Bool
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var name: String?
    @NSManaged public var phone: Int64
    @NSManaged public var photo: String?
    @NSManaged public var type: String?
    @NSManaged public var city: City?
    @NSManaged public var photos: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var workingTimes: NSSet?

}

// MARK: Generated accessors for photos
extension Place {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Place {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for workingTimes
extension Place {

    @objc(addWorkingTimesObject:)
    @NSManaged public func addToWorkingTimes(_ value: WorkingTime)

    @objc(removeWorkingTimesObject:)
    @NSManaged public func removeFromWorkingTimes(_ value: WorkingTime)

    @objc(addWorkingTimes:)
    @NSManaged public func addToWorkingTimes(_ values: NSSet)

    @objc(removeWorkingTimes:)
    @NSManaged public func removeFromWorkingTimes(_ values: NSSet)

}

extension Place : Identifiable {

}
