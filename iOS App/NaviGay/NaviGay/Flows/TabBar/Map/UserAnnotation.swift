//
//  UserAnnotation.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 16.06.23.
//

import MapKit

final class UserAnnotation: NSObject, MKAnnotation {
    public let identifier = "UserAnnotation"
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
