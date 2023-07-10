//
//  LocationManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 14.06.23.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var userLocation: CLLocation? {get}
    var authorizationStatus: ((LocationStatus) -> Void)? { get set }
    var newUserLocation: ((CLLocation) -> Void)? { get set }
}

enum LocationStatus {
    case authorized, denied
}

final class LocationManager: NSObject, LocationManagerProtocol {
    
    //MARK: - Properties
    
    var userLocation: CLLocation?
    var authorizationStatus: ((LocationStatus) -> Void)?
    var newUserLocation: ((CLLocation) -> Void)?
    
    // MARK: - Private Properties
    
    private let manager = CLLocationManager()
    
    // MARK: - Inits
    
    override init() {
        super.init()
        manager.pausesLocationUpdatesAutomatically = true
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    //MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationStatus?(.authorized)
            manager.requestLocation()
        case .denied:
            authorizationStatus?(.denied)
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("---ERROR--- TabBarViewModel locationManager didFailWithError" , error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        userLocation = currentLocation
        newUserLocation?(currentLocation)
        manager.stopUpdatingLocation()
    }
}

