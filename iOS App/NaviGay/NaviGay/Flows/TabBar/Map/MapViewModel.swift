//
//  MapViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import SwiftUI
import MapKit

final class MapViewModel: NSObject, ObservableObject {
    
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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))//
        
        if let userLocation = locationManager.userLocation {
            self.userLocation = userLocation
            updateAnnotations()
            getPlaces(userLocation: userLocation)
        }
        self.locationManager.newUserLocation = { [weak self] location in
            self?.userLocation = location
            self?.getPlaces(userLocation: location)
            self?.updateAnnotations()
        }
    }
}

extension MapViewModel: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? PlaceAnnotation {
            annotationView = setupPlaceAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    @MainActor func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if annotation is PlaceAnnotation {
            Task {
                selectedAnnotation = annotation
            }

            let sourceCoordinate = mapView.userLocation.coordinate
            let destinationCoordinate = annotation.coordinate

            let directions = directions(from: sourceCoordinate, to: destinationCoordinate, transportType: .walking)

            directions.calculate { response, error in
                guard error == nil, let route = response?.routes.first else {
                    return
                }
                if !mapView.overlays.isEmpty {
                    mapView.removeOverlays(mapView.overlays)
                }
                mapView.addOverlay(route.polyline)
            }
            directions.cancel()
        }
    }

    @MainActor func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        Task {
            selectedAnnotation = nil
        }
    }
}

extension MapViewModel {
    
    func updateAnnotations() {
        
        if mapView.annotations.count != places.count + 1 { /// +1 - User location annotation
            mapView.removeAnnotations(mapView.annotations) // Удаление всех существующих аннотаций
            for place in places {
                let placeAnnotation = PlaceAnnotation(id: place.objectID,
                                                      coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(place.latitude), longitude: CLLocationDegrees(place.longitude)),
                                                      title: place.name,
                                                      subtitle: place.about,
                                                      type: place.type ?? "")
                mapView.addAnnotation(placeAnnotation)
            }
        }
//        let region = viewModel.getRegion(userLocation: uiView.userLocation.coordinate, locations: locations, celectedLocation: celectedLocation)
//        uiView.setRegion(region, animated: true)
        
        
        
        if let region = getRegion() {
            mapView.setRegion(region, animated: true)
        }
    }
    
        func getRegion() -> MKCoordinateRegion? {
            let placesCoordinates = places.map({CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))})
            
            var mapLocations: [CLLocationCoordinate2D] = []
            
            guard let userCoordinate = userLocation?.coordinate else {
                return nil
            }
            mapLocations.append(userCoordinate)
            
            if let selectedAnnotationCoordinate = selectedAnnotation?.coordinate {
                mapLocations.append(selectedAnnotationCoordinate)
                return regionThatFitsTo(coordinates: mapLocations)
            } else {
                if places.isEmpty {
                    return MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                } else {
                    for coordinate in placesCoordinates {
                        mapLocations.append(coordinate)
                    }
                    return regionThatFitsTo(coordinates: mapLocations)
                }
            }
    }
    
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
    
    private func setupPlaceAnnotationView(for annotation: PlaceAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PINPLACE")
        marker.isDraggable = false
        marker.animatesWhenAdded = true
        marker.displayPriority = .required
        marker.largeContentTitle = annotation.title // ??????
        marker.canShowCallout = true // Если ДА, при выборе аннотации будет отображаться стандартная выноска. Для отображения выноски аннотация должна иметь заголовок. ?????
        marker.titleVisibility = .visible
        marker.subtitleVisibility = .visible
        
        switch annotation.type {
        case "bar":
            marker.markerTintColor = .cyan
            marker.glyphImage = AppImages.mapBarIcon
            //marker.selectedGlyphImage = AppImages.mapClubIcon
            marker.glyphTintColor = .white
        case "cafe":
            marker.markerTintColor = .systemOrange
            marker.glyphImage = AppImages.mapCafeIcon
            marker.glyphTintColor = .systemIndigo
        case "club":
            marker.markerTintColor = .yellow
            marker.glyphImage = AppImages.mapClubIcon
        case "restaurant":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapRestaurantIcon
        case "hotel":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapHotelIcon
        case "sauna":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapSaunaIcon
        case "cruise":
            marker.markerTintColor = .red
            marker.glyphImage = AppImages.mapCruiseIcon
            marker.glyphTintColor = .systemYellow
        case "beach":
            marker.markerTintColor = .yellow
            marker.glyphImage = AppImages.mapBeachIcon
            marker.glyphTintColor = .systemBlue
        case "shop":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapShopIcon
        case "gym":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapGymIcon
        case "culture":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapCultureIcon
        case "community":
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapCommunityIcon
        default:
            marker.markerTintColor = .white
        }
        return marker
    }
    
    private func directions(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) -> MKDirections {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        return MKDirections(request: request)
    }
}
