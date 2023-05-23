//
//  PlaceTag+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension PlaceTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceTag> {
        return NSFetchRequest<PlaceTag>(entityName: "PlaceTag")
    }

    @NSManaged public var name: String?
    @NSManaged public var place: Place?

}

extension PlaceTag : Identifiable {

}
