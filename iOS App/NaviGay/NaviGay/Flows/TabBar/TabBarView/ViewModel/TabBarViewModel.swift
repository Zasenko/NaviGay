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

final class TabBarViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedPage: TabBarRouter = TabBarRouter.home
    @Published var showLocationAlert: Bool = false
    @Published var isLocationDenied: Bool = false
    
    @Binding var isUserLogin: Bool
    
    var safeArea: EdgeInsets?
    var size: CGSize?
    
    var locationManager: LocationManagerProtocol
    
    lazy var catalogNetworkManager = CatalogNetworkManager()
    lazy var catalogDataManager = CatalogDataManager(manager: dataManager)
    lazy var mapDataManager = MapDataManager(manager: dataManager)
    
    let mapButton = TabBarButton(title: "Map", img: AppImages.iconMap, page: .map)
    let calendarButton = TabBarButton(title: "Calendar", img: AppImages.iconCalendar, page: .home)
    let catalogButton = TabBarButton(title: "Catalog", img: AppImages.iconSearch, page: .catalog)
    let userButton = TabBarButton(title: "User", img: AppImages.iconPerson, page: .user)
    
    // MARK: - Private Properties
    
    private let dataManager: CoreDataManagerProtocol
    
    
    // MARK: - Inits
    
    init(isUserLogin: Binding<Bool>,
         dataManager: CoreDataManagerProtocol, locationManager: LocationManagerProtocol) {
        _isUserLogin = isUserLogin
        self.dataManager = dataManager
        self.locationManager = locationManager
        
        self.locationManager.authorizationStatus = { [weak self] result in
            switch result {
            case .authorized:
                self?.isLocationDenied = false
                self?.selectedPage = .home
            case .denied:
                self?.showLocationAlert.toggle()
            }
        }
        
        self.locationManager.newUserLocation = { [weak self] location in
            self?.fetchPlacesAroundMe(location: location)
        }
    }
}

extension TabBarViewModel {
    
    // MARK: - Functions
    
    func settingsButtonTapped() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        isLocationDenied = true
        selectedPage = .catalog
    }
    
    func cancleButtonTapped() {
        isLocationDenied = true
        selectedPage = .catalog
    }
    
    // MARK: - Private Functions
    
    private func fetchPlacesAroundMe(location: CLLocation) {
        
    }
}
