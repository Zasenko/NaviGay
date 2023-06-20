//
//  MapViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 15.06.23.
//

import SwiftUI
import MapKit

final class MapViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var mapView = MKMapView()
    @Published var mapType: MKMapType = .standard //TODO!
    @Published var userLocation: CLLocation?
    @Published var selectedAnnotation: MKAnnotation?
    @Published var selectedPlace: Place?
    @Published var selectedEvent: Event?
    @Published var places: [Place] = []
    @Published var events: [Event] = []
    @Published var showInfoSheet = false
    
    // MARK: - Private Properties
    
    private var locationManager: LocationManagerProtocol
    private let dataManager: MapDataManagerProtocol
    
    // MARK: - Inits
    
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
            getLocations(userLocation: userLocation)
        }
        
        self.locationManager.newUserLocation = { [weak self] location in
            self?.userLocation = location
           self?.updateAnnotations()
            self?.getLocations(userLocation: location)
        }
    }
}

extension MapViewModel: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 4
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        var annotationView: MKAnnotationView?
        if let placeAnnotation = annotation as? PlaceAnnotation {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(
                withIdentifier: placeAnnotation.identifier) as? MKMarkerAnnotationView {
                annotationView = setupPlaceAnnotationView(for: dequeuedView, type: placeAnnotation.type)
            } else {
                let marker = MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: placeAnnotation.identifier)
                annotationView = setupPlaceAnnotationView(for: marker, type: placeAnnotation.type)
            }
        } else if let eventAnnotation = annotation as? EventAnnotation {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(
                withIdentifier: eventAnnotation.identifier) as? MKMarkerAnnotationView {
                annotationView = setupEventAnnotationView(for:  dequeuedView)
            } else {
                let marker = MKMarkerAnnotationView(annotation: eventAnnotation, reuseIdentifier: eventAnnotation.identifier)
                annotationView = setupEventAnnotationView(for: marker)
            }
        }
        return annotationView
    }
    
    @MainActor
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        Task {
            if annotation is PlaceAnnotation {
                withAnimation(.spring()) {
                    self.showInfoSheet = true
                    self.selectedAnnotation = annotation
                    self.selectedPlace = self.getPlace()
                }
                //            let sourceCoordinate = mapView.userLocation.coordinate
                //            let destinationCoordinate = annotation.coordinate
                //
                //            let directions = directions(from: sourceCoordinate, to: destinationCoordinate, transportType: .walking)
                //
                //            directions.calculate { response, error in
                //                guard error == nil, let route = response?.routes.first else {
                //                    return
                //                }
                //                if !mapView.overlays.isEmpty {
                //                    mapView.removeOverlays(mapView.overlays)
                //                }
                //                mapView.addOverlay(route.polyline)
                //            }
                //            directions.cancel()
            } else if annotation is EventAnnotation {
                withAnimation(.spring()) {
                    self.showInfoSheet = false
                    self.selectedAnnotation = nil
                    self.selectedAnnotation = annotation
                    // selectedPlace = getPlace()
                }
            }
        }
    }
    
    @MainActor
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        //  let overlays = mapView.overlays
        // mapView.removeOverlays(overlays)
        Task {
            withAnimation() {
                    self.selectedAnnotation = nil
                    self.showInfoSheet = false
                    self.selectedAnnotation = nil
                
            }
        }

    }
}

extension MapViewModel {
    
    // MARK: - Functions
    
    private func getPlace() -> Place? {
        guard let placeAnnotatio = selectedAnnotation as? PlaceAnnotation else {
            return nil
        }
        guard let place = places.first(where: { $0.objectID == placeAnnotatio.objectID}) else {
            return nil
        }
        return place
    }
    
    func updateAnnotations() {
        //TODO!!!!! проверка аннотаций
        if mapView.annotations.count != (places.count + events.count + 1) { /// +1 - User location annotation
            mapView.removeAnnotations(mapView.annotations) // Удаление всех существующих аннотаций
            for place in places {
                let placeAnnotation = PlaceAnnotation(place: place)
                mapView.addAnnotation(placeAnnotation)
            }
            for event in events {
                let eventAnnotation = EventAnnotation(id: event.objectID,
                                                      coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(event.latitude), longitude: CLLocationDegrees(event.longitude)),
                                                      title: event.name)
                mapView.addAnnotation(eventAnnotation)
            }
        }
        
        if let region = getRegion() {
            mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Private Functions
    
    private func getRegion() -> MKCoordinateRegion? {
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
    
    private func getLocations(userLocation: CLLocation) {
        Task {
            switch await dataManager.getLocations(userLocation: userLocation) {
            case .success(let locations):
                DispatchQueue.main.sync {
                    self.places = locations.places
                    self.events = locations.events
                    updateAnnotations()
                }
        //    case .success(let places):
//                DispatchQueue.main.sync {
//                    self.places = places
//                    updateAnnotations()
//                }
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
    
    private func setupPlaceAnnotationView(for marker: MKMarkerAnnotationView, type: String) -> MKAnnotationView {
        marker.isDraggable = false
        marker.animatesWhenAdded = true
        marker.displayPriority = .required
        marker.canShowCallout = false
        marker.titleVisibility = .hidden
        marker.subtitleVisibility = .hidden
        switch type {
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
    
    private func setupEventAnnotationView(for marker: MKMarkerAnnotationView) -> MKAnnotationView {
        marker.isDraggable = false
        marker.animatesWhenAdded = true
        marker.displayPriority = .required
        marker.canShowCallout = false
        marker.titleVisibility = .hidden
        marker.subtitleVisibility = .hidden
        
        marker.markerTintColor = .systemYellow
            marker.glyphImage = AppImages.mapPartyIcon
            //marker.selectedGlyphImage = AppImages.mapClubIcon
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
