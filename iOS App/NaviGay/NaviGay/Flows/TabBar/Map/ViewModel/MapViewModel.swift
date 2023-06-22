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
    
    @Published var showInfoSheet = false
    @Published var selectedAnnotation: MKAnnotation?
    @Published var selectedPlace: Place?
    @Published var selectedEvent: Event?
    
    var places: [Place] = []
    var events: [Event] = []
    
    var placesAnnotations: [PlaceAnnotation] = []
    var eventsAnnotations: [EventAnnotation] = []
    
    @Published var filteredAnnotations: [MKAnnotation] = []
    
    @Published var sortingCategories: [SortingMenuCategories] = []
    @Published var selectedSortingCategory: SortingMenuCategories = .all
    
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
        mapView.isRotateEnabled = true
        
        registerMapAnnotationViews()
        
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

extension MapViewModel {
    
    // MARK: - Functions
    
    func updateAnnotations() {
        if let region = getRegion() {
            mapView.setRegion(region, animated: true)
        }
        let existingAnnotations = mapView.annotations
        let annotationsToRemove = existingAnnotations.filter { annotation in
            return !filteredAnnotations.contains { filteredAnnotation in
                return annotation.coordinate == filteredAnnotation.coordinate
            }
        }
        
        let annotationsToAdd = filteredAnnotations.filter { filteredAnnotation in
            return !existingAnnotations.contains { annotation in
                return annotation.coordinate == filteredAnnotation.coordinate
            }
        }
        mapView.removeAnnotations(annotationsToRemove)
        mapView.addAnnotations(annotationsToAdd)
    }
    
    func sortingButtonTapped(category: SortingMenuCategories) {
        withAnimation {
            selectedAnnotation = nil
            selectedPlace = nil
            selectedEvent = nil
            selectedSortingCategory = category
        }
        switch category {
        case .bar:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .bar } )
        case .cafe:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .cafe } )
        case .restaurant:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .restaurant } )
        case .club:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .club } )
        case .hotel:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .hotel } )
        case .sauna:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .sauna } )
        case .cruise:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .cruise } )
        case .beach:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .beach } )
        case .shop:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .shop } )
        case .gym:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .gym } )
        case .culture:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .culture } )
        case .community:
            filteredAnnotations = placesAnnotations.filter( { $0.type == .community } )
        case .events:
            filteredAnnotations = eventsAnnotations
        case .other:
            filteredAnnotations = eventsAnnotations + placesAnnotations
        case .all:
            filteredAnnotations = eventsAnnotations + placesAnnotations
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
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? PlaceAnnotation {
            annotationView = setupPlaceAnnotationView(for: annotation, on: mapView)
        } else if let annotation = annotation as? EventAnnotation {
            annotationView = setupEventAnnotationView(for: annotation, on: mapView)
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
            } else if annotation is EventAnnotation {
                withAnimation(.spring()) {
                    self.showInfoSheet = false
                    self.selectedAnnotation = annotation
                    self.selectedEvent = getEvent()
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
                self.showInfoSheet = false
                self.selectedAnnotation = nil
            }
        }
    }
}

extension MapViewModel {
    
    // MARK: - Private Functions
    
    private func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(EventAnnotation.self))
    }
    
    private func updateSortingCategories() {
        let stringTypes = places.compactMap( { $0.type} ).uniqued()
        var categories = stringTypes.compactMap { stringType in
            guard let category = SortingMenuCategories(rawValue: stringType) else {
                return SortingMenuCategories.other
            }
            return category
        }
        if categories.count > 1 {
            categories.append(.all)
        }
        self.sortingCategories = categories
    }
    
    private func getRegion() -> MKCoordinateRegion? {
        let annotationsCoordinates = filteredAnnotations.map { $0.coordinate }
        
        // places.map { CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude)) }
        var mapLocations: [CLLocationCoordinate2D] = []
        guard let userCoordinate = userLocation?.coordinate else { return nil }
        mapLocations.append(userCoordinate)
        if let selectedAnnotationCoordinate = selectedAnnotation?.coordinate {
            mapLocations.append(selectedAnnotationCoordinate)
            return regionThatFitsTo(coordinates: mapLocations)
        } else {
            guard !places.isEmpty else {
                return MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            }
            annotationsCoordinates.forEach( { mapLocations.append($0) } )
            return regionThatFitsTo(coordinates: mapLocations)
        }
    }
    
    private func getLocations(userLocation: CLLocation) {
        Task {
            switch await dataManager.getLocations(userLocation: userLocation) {
            case .success(let locations):
                DispatchQueue.main.async {
                    self.places = []
                    self.events = []
                    self.placesAnnotations = []
                    self.eventsAnnotations = []
                    self.filteredAnnotations = []
                    
                    self.places = locations.places
                    self.events = locations.events
                    
                    locations.places.forEach { self.placesAnnotations.append(PlaceAnnotation(place: $0)) }
                    locations.events.forEach { self.eventsAnnotations.append(EventAnnotation(event: $0)) }
                    
                    locations.places.forEach { self.filteredAnnotations.append(PlaceAnnotation(place: $0)) }
                    locations.events.forEach { self.filteredAnnotations.append(EventAnnotation(event: $0)) }
                    
                    self.updateAnnotations()
                    self.updateSortingCategories()
                }
            case .failure(let error):
                print("ERROR MapViewModel getPlaces(userLocation: CLLocation):", error)
            }
        }
    }
    
    private func getPlace() -> Place? {
        guard let anatation = selectedAnnotation as? PlaceAnnotation else {
            return nil
        }
        guard let place = places.first(where: { $0.objectID == anatation.objectID}) else {
            return nil
        }
        return place
    }
    
    private func getEvent() -> Event? {
        guard let anatation = selectedAnnotation as? EventAnnotation else {
            return nil
        }
        guard let event = events.first(where: { $0.objectID == anatation.objectID}) else {
            return nil
        }
        return event
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
        let reuseIdentifier = NSStringFromClass(PlaceAnnotation.self)
        let marker = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        marker.animatesWhenAdded = true
        marker.displayPriority = .required
        marker.canShowCallout = false
        marker.titleVisibility = .hidden
        marker.subtitleVisibility = .hidden
        switch annotation.type {
        case .bar:
            marker.glyphText = "🍷"
            marker.markerTintColor = .cyan
        case .cafe:
            marker.glyphText = "☕️"
            marker.markerTintColor = .systemOrange
        case .club:
            marker.glyphText = "💃"
        case .restaurant:
            marker.markerTintColor = .green
        case .hotel:
            marker.markerTintColor = .purple
        case .sauna:
            marker.glyphText = "🧖‍♂️"
        case .cruise:
            marker.glyphText = "🍆"
            marker.markerTintColor = .black
            marker.glyphTintColor = .red
        case .beach:
            marker.glyphText = "⛱️"
            marker.markerTintColor = .green
        case .shop:
            marker.markerTintColor = .magenta
            marker.glyphImage = AppImages.mapShopIcon
        case .gym:
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapGymIcon
        case .culture:
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapCultureIcon
        case .community:
            marker.markerTintColor = .purple
            marker.glyphImage = AppImages.mapCommunityIcon
        case .defaultValue:
            marker.glyphImage = AppImages.mapCommunityIcon
        }
        return marker
    }
    
    private func setupEventAnnotationView(for annotation: EventAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(EventAnnotation.self)
        let marker = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        marker.animatesWhenAdded = true
        marker.displayPriority = .required
        marker.canShowCallout = false
        marker.markerTintColor = .systemPink
        //  marker.detailCalloutAccessoryView = AppImages.mapCultureIcon.map(UIImageView.init)
        ///картинка при клике
        marker.titleVisibility = .hidden
        marker.subtitleVisibility = .hidden
        marker.glyphText = "🎉"
        //marker.glyphImage = AppImages.mapPartyIcon
        // marker.selectedGlyphImage = AppImages.mapHotelIcon
        marker.markerTintColor = .red
        marker.glyphTintColor = .white
        //        let rightButton = UIButton(type: .detailDisclosure)
        //        marker.rightCalloutAccessoryView = rightButton
        ///or marker.leftCalloutAccessoryView = rightButton
        //  let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
        //  marker.centerOffset = offset
        
        return marker
    }
    
    //    private func directions(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) -> MKDirections {
    //        let request = MKDirections.Request()
    //        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
    //        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
    //        request.requestsAlternateRoutes = false
    //        request.transportType = .walking
    //        return MKDirections(request: request)
    //    }
}
