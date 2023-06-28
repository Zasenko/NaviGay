//
//  PlaceAnnotation.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import MapKit
import CoreData

final class PlaceAnnotation: NSObject, MKAnnotation, Identifiable {
    public let identifier = "PlaceAnnotation"
    
    let objectID: NSManagedObjectID
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let type: PlaceType
    var img: UIImage? = UIImage(systemName: "heart.fill")
    
    init(place: Place) {
        self.objectID = place.objectID
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.latitude),
                                                 longitude: CLLocationDegrees(place.longitude))
        self.title = place.name
        self.subtitle = place.type
        self.type = PlaceType(rawValue: place.type ?? "other") ?? .other// place.type ?? ""

        switch type {
        case .bar:
            self.img = AppImages.mapBarIcon
        case .cafe:
            self.img = AppImages.mapCafeIcon
        case .club:
            self.img = AppImages.mapClubIcon
        case .restaurant:
            self.img = AppImages.mapRestaurantIcon
        case .hotel:
            self.img = AppImages.mapHotelIcon
        case .sauna:
            self.img = AppImages.mapSaunaIcon
        case .cruise:
            self.img = AppImages.mapCruiseIcon
        case .beach:
            self.img = AppImages.mapBeachIcon
        case .shop:
            self.img = AppImages.mapShopIcon
        case .gym:
            self.img = AppImages.mapGymIcon
        case .culture:
            self.img = AppImages.mapCultureIcon
        case .community:
            self.img = AppImages.mapCommunityIcon
        default:
            self.img = AppImages.mapCommunityIcon
        }
    }
}
