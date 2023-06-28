//
//  Place+CoreDataClass.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


public class Place: NSManagedObject {

}

extension Place {
    func updateBasic(decodedPlace: DecodedPlace) {
        self.id = id
        self.name = decodedPlace.name
        self.type = decodedPlace.type.rawValue
        self.photo = decodedPlace.photo
        self.address = decodedPlace.address
        self.latitude = decodedPlace.latitude
        self.longitude = decodedPlace.longitude
        self.isActive = decodedPlace.isActive == 1 ? true : false
        self.isChecked = decodedPlace.isChecked == 1 ? true : false
    }
}
