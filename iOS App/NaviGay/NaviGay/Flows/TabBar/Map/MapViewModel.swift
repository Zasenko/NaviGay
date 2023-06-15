//
//  MapViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import SwiftUI
import MapKit

final class MapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
    
    @Published var mapView = MKMapView()
    @Published var mapType: MKMapType = .standard
    
    @Published var userLocation: CLLocation?
    @Published var selectedAnnotation: MKAnnotation?
    
    @Published var places: [Place] = []
    
    private var locationManager: LocationManagerProtocol
    private let dataManager: MapDataManagerProtocol
    
    init(locationManager: LocationManagerProtocol, dataManager: MapDataManagerProtocol) {
        self.locationManager = locationManager
        self.dataManager = dataManager
        super.init()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if let userLocation = locationManager.userLocation {
            self.userLocation = userLocation
            getPlaces(userLocation: userLocation)
        }
        
        self.locationManager.newUserLocation = { [weak self] location in
            self?.userLocation = location
            self?.getPlaces(userLocation: location)
            self?.updateAnnotations()
        }
        
        updateAnnotations()
    }
    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        DispatchQueue.main.async {
//            self.selectedAnnotation = nil
//        }
//        
//    }
//    
//    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
//        guard let annotation = annotation as? PlaceAnnotation else {
//            return
//        }
//        DispatchQueue.main.async {
//            self.selectedAnnotation = annotation
//        }
//        
//        print(annotation.id)
//    }
//    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        DispatchQueue.main.async {
            self.selectedAnnotation = nil
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        else {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN")
            marker.isDraggable = false
            marker.animatesWhenAdded = true
            marker.displayPriority = .required
            marker.canShowCallout = false // Если ДА, при выборе аннотации будет отображаться стандартная выноска. Для отображения выноски аннотация должна иметь заголовок.
            marker.titleVisibility = .hidden
            marker.subtitleVisibility = .hidden
            
            if let placeAnnotation = annotation as? PlaceAnnotation {
                switch placeAnnotation.type {
                case "bar":
                    marker.markerTintColor = .blue
                    marker.glyphImage = AppImages.mapBarIcon
//                    marker.selectedGlyphImage = AppImages.mapClubIcon
//                    marker.glyphTintColor = .red
                case "cafe":
                    marker.markerTintColor = .magenta
                    marker.glyphImage = AppImages.mapCafeIcon
                case "club":
                    marker.markerTintColor = .yellow
                    marker.glyphImage = AppImages.mapClubIcon
                default:
                    marker.markerTintColor = .orange
                }
            }
            return marker
        }
    }
    
    func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations) // Удаление всех существующих аннотаций
        
        for place in places {
            let placeAnnotation = PlaceAnnotation(id: place.objectID,
                                                  coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(place.latitude),
                                                                                     longitude: CLLocationDegrees(place.longitude)),
                                                  title: place.name,
                                                  subtitle: nil,
                                                  type: place.type ?? "")
            mapView.addAnnotation(placeAnnotation)
        }
                
        var placesCoordinates = places.map({CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))})
        
        if let userCoor = userLocation?.coordinate {
            placesCoordinates.append(userCoor)
        }
        
        if !placesCoordinates.isEmpty {
            mapView.region = regionThatFitsTo(coordinates: placesCoordinates)
        }
    }
    
//    func getRegion() -> MKCoordinateRegion {
//
//        var placesCoordinates = places.map({CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)})
//        var userCoor = userLocation?.coordinate
//
//        var mapLocations: [CLLocationCoordinate2D] = [userLocation]
//
//        guard let celectedLocationCoordinate = celectedLocation?.coordinate else {
//            if locations.isEmpty {
//                return MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
//            } else {
//                for i in locations {
//                    mapLocations.append(i.coordinate)
//                }
//                return regionThatFitsTo(coordinates: mapLocations)
//            }
//        }
//        mapLocations.append(celectedLocationCoordinate)
//        return regionThatFitsTo(coordinates: mapLocations)
//    }
    
    private func getPlaces(userLocation: CLLocation) {
        Task {
            switch await dataManager.getPlaces(userLocation: userLocation) {
            case .success(let places):
                DispatchQueue.main.sync {
                    self.places = places
                    updateAnnotations()
                }
            case .failure(let error):
                print("ERROR MapViewModel getPlaces(userLocation: CLLocation):", error)
            }
        }
    }

    private func regionThatFitsTo(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for coordinate in coordinates {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
        }
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4
        return region
    }
}

//MARK: - UIKit MapView

struct UIKitMapView: UIViewRepresentable {
    
    @ObservedObject var mapViewModel: MapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        return mapViewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        mapViewModel.updateAnnotations()
    }
}
