//
//  MapDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import CoreData
import CoreLocation

protocol MapDataManagerProtocol {
    func getPlaces(userLocation: CLLocation) async -> Result<[Place], Error>
}


final class MapDataManager {
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}


extension MapDataManager: MapDataManagerProtocol {
    // MARK: - PlaceDataManagerProtocol
    
    func getPlaces(userLocation: CLLocation) async -> Result<[Place], Error> {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        
        let searchDistance:Double =  3.90 //float value in KM
        let minLat = userLocation.coordinate.latitude - (searchDistance / 69)
        let maxLat = userLocation.coordinate.latitude + (searchDistance / 69)
        let minLon = userLocation.coordinate.longitude - searchDistance / fabs(cos(deg2rad(degrees: userLocation.coordinate.latitude))*69)
        let maxLon = userLocation.coordinate.longitude + searchDistance / fabs(cos(deg2rad(degrees: userLocation.coordinate.latitude))*69)

        let predicate = NSPredicate(format: "latitude <= \(maxLat) AND latitude >= \(minLat) AND longitude <= \(maxLon) AND longitude >= \(minLon)")
        fetchRequest.predicate = predicate
        
        do {
            let places = try self.manager.context.fetch(fetchRequest)
            return .success(places)
        } catch let error {
            return.failure(error)
        }
    }
}

extension MapDataManager {
    
    // MARK: - Private Functions
    
    private func deg2rad(degrees:Double) -> Double{
        return degrees * Double.pi / 180
    }
}
