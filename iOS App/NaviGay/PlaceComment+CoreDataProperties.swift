//
//  PlaceComment+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//
//

import Foundation
import CoreData


extension PlaceComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceComment> {
        return NSFetchRequest<PlaceComment>(entityName: "PlaceComment")
    }

    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var userId: Int64
    @NSManaged public var userName: String?
    @NSManaged public var userPhoto: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var place: Place?

}

extension PlaceComment : Identifiable {

}
