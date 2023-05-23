//
//  Photo+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var url: String?
    @NSManaged public var place: Place?

}

extension Photo : Identifiable {

}
