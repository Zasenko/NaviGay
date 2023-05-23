//
//  User+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bio: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var status: String?

}

extension User : Identifiable {

}
