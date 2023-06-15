//
//  PlaceAnnotation.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import MapKit
import CoreData

class PlaceAnnotation: NSObject, MKAnnotation, Identifiable {
  //  public let identifier = "PlaceAnnotation"
    
    let id: NSManagedObjectID
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let type: String
    
    init(id: NSManagedObjectID, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, type: String) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}
