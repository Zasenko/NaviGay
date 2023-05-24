//
//  WorkingTime+CoreDataProperties.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//
//

import Foundation
import CoreData


extension WorkingTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkingTime> {
        return NSFetchRequest<WorkingTime>(entityName: "WorkingTime")
    }

    @NSManaged public var close: String?
    @NSManaged public var day: String?
    @NSManaged public var open: String?
    @NSManaged public var place: Place?

}

extension WorkingTime : Identifiable {

}
