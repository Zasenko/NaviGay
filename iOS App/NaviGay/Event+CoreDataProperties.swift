//
//  Event+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.05.23.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var about: String?
    @NSManaged public var aboutEn: String?
    @NSManaged public var address: String?
    @NSManaged public var cover: String?
    @NSManaged public var fb: String?
    @NSManaged public var fee: Int16
    @NSManaged public var feeAbout: String?
    @NSManaged public var finishTime: Date?
    @NSManaged public var id: Int64
    @NSManaged public var insta: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var isChecked: Bool
    @NSManaged public var lang: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var name: String?
    @NSManaged public var phone: Int32
    @NSManaged public var placeName: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var tickets: String?
    @NSManaged public var type: String?
    @NSManaged public var www: String?
    @NSManaged public var city: City?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension Event {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Event : Identifiable {

}
