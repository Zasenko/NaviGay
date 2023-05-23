//
//  Event+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var about: String?
    @NSManaged public var about_en: String?
    @NSManaged public var address: String?
    @NSManaged public var cover: String?
    @NSManaged public var fb: String?
    @NSManaged public var fee: Int16
    @NSManaged public var fee_about: String?
    @NSManaged public var finish_time: Date?
    @NSManaged public var id: Int64
    @NSManaged public var insta: String?
    @NSManaged public var is_active: Bool
    @NSManaged public var is_checked: Bool
    @NSManaged public var lang: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var placeName: String?
    @NSManaged public var start_time: Date?
    @NSManaged public var tickets: String?
    @NSManaged public var www: String?

}

extension Event : Identifiable {

}
