//
//  TabBarViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI
import CoreLocation

enum TabBarRouter {
    case catalog
    case map
    case home
    case user
}

final class TabBarViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedPage: TabBarRouter = TabBarRouter.home
    @Published var userLocation: CLLocation?
    @Published var showLocationAlert: Bool = false
    @Published var isLocationDenied: Bool = false
    
    @Binding var isUserLogin: Bool
    
    lazy var catalogNetworkManager = CatalogNetworkManager()
    lazy var catalogDataManager = CatalogDataManager(manager: dataManager)
    
    let mapButton = TabBarButton(id: 1,
                          title: "Map",
                          img: AppImages.iconMap,
                          page: .map)
    let calendarButton = TabBarButton(id: 2,
                                      title: "Calendar",
                                      img: AppImages.iconCalendar,
                                      page: .home)
    let catalogButton = TabBarButton(id: 3,
                                     title: "Catalog",
                                     img: AppImages.iconSearch,
                                     page: .catalog)
    let userButton = TabBarButton(id: 4,
                                  title: "User",
                                  img: AppImages.iconPerson,
                                  page: .user)

    // MARK: - Private Properties
    
    private let dataManager: CoreDataManagerProtocol
    private let locationManager = CLLocationManager()
    
    // MARK: - Inits
    
    init(isUserLogin: Binding<Bool>,
         dataManager: CoreDataManagerProtocol) {
        _isUserLogin = isUserLogin
        self.dataManager = dataManager
        super.init()

        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension TabBarViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.requestLocation()
                self.isLocationDenied = false
                self.selectedPage = .home
            case .denied:
                self.showLocationAlert.toggle()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default: ()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        print("--- TabBarViewModel - locationManager didUpdateLocations () ---")
        self.userLocation = currentLocation
        print("currentLocation: " , currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO
        print("--- TabBarViewModel - locationManager didFailWithError () ---")
        print(error.localizedDescription)
        print("---")
        print(error)
    }
}

// MARK: - Functions
extension TabBarViewModel {
    func settingsButtonTapped() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        isLocationDenied = true
        selectedPage = .catalog
    }
    
    func cancleButtonTapped() {
        isLocationDenied = true
        selectedPage = .catalog
    }
}
