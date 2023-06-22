//
//  CLLocationCoordinate2DExtention.swift.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.06.23.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
