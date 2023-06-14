////
////  LocationManager.swift
////  NaviGay
////
////  Created by Dmitry Zasenko on 14.06.23.
////
//
//import Foundation
//import CoreLocation
//import MapKit
//import Combine
//
//class LocationManager: NSObject, ObservableObject {
//    
//    //MARK: - Properties
//    @Published var userLocation: CLLocation?
//    @Published var authorizationStatus: CLAuthorizationStatus
//    
//    private let manager = CLLocationManager()
//    
//    override init() {
//        self.authorizationStatus = manager.authorizationStatus
//        super.init()
//        manager.delegate = self
//        manager.requestWhenInUseAuthorization()
//    }
//}
//
////MARK: - CLLocationManagerDelegate
//extension LocationManager: CLLocationManagerDelegate {
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedAlways, .authorizedWhenInUse:
//            manager.requestLocation()
//        case .denied:
//            //TODO
//            handleLocationError()
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//        default: ()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    //TODO
//    func handleLocationError() {
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.last else { return }
//        self.userLocation = currentLocation
//    }
//}
//
