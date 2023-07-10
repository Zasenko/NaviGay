//
//  TabBarViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI
import CoreLocation

enum TabBarRouter {
    case aroundMe, search, user
}
enum AroundMeRouter {
    case map, home
}

final class TabBarViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Binding var user: User?
    @Binding var isUserLoggedIn: Bool
    @Binding var entryRouter: EntryViewRouter
    
    @Published var selectedPage: TabBarRouter = TabBarRouter.aroundMe
    @Published var aroundMeSelectedPage: AroundMeRouter = .home
    @Published var showLocationAlert: Bool = false
    @Published var isLocationDenied: Bool = false
        
    var locationManager: LocationManagerProtocol
    let userDataManager: UserDataManagerProtocol
    let keychinWrapper: KeychainWrapperProtocol
    
    
    private let aroundNetworkManager: AroundNetworkManagerProtocol = AroundNetworkManager()
    
    lazy var catalogNetworkManager: CatalogNetworkManagerProtocol = CatalogNetworkManager()
    lazy var catalogDataManager: CatalogDataManagerProtocol = CatalogDataManager(manager: dataManager)
    lazy var placeNetworkManager: PlaceNetworkManagerProtocol = PlaceNetworkManager()
    lazy var placeDataManager: PlaceDataManagerProtocol = PlaceDataManager(manager: dataManager)
    lazy var mapDataManager: MapDataManagerProtocol = MapDataManager(manager: dataManager)
    
    let aroundMeButton = TabBarButton(title: "Around Me", img: AppImages.iconCalendar, page: .aroundMe)
    let catalogButton = TabBarButton(title: "Catalog", img: AppImages.iconSearch, page: .search)
    
    // MARK: - Private Properties
    
    private let dataManager: CoreDataManagerProtocol //TODO ???? зачем это тут
    
    // MARK: - Inits
    
    init(isUserLoggedIn: Binding<Bool>,
         entryRouter: Binding<EntryViewRouter>,
         user: Binding<User?>,
         dataManager: CoreDataManagerProtocol,
         locationManager: LocationManagerProtocol,
         userDataManager: UserDataManagerProtocol,
         keychinWrapper: KeychainWrapperProtocol) {
        _isUserLoggedIn = isUserLoggedIn
        _entryRouter = entryRouter
        _user = user
        self.dataManager = dataManager
        self.locationManager = locationManager
        self.userDataManager = userDataManager
        self.keychinWrapper = keychinWrapper
        
        self.locationManager.authorizationStatus = { [weak self] result in
            switch result {
            case .authorized:
                self?.isLocationDenied = false
                self?.selectedPage = .aroundMe
            case .denied:
                self?.showLocationAlert.toggle()
            }
        }
        
        self.locationManager.newUserLocation = { [weak self] location in
            self?.fetchLocationsAroundMe(userLocation: location)
        }
    }
}

extension TabBarViewModel {
    
    // MARK: - Functions
    
    func settingsButtonTapped() {
        isLocationDenied = true
        selectedPage = .search
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func cancleButtonTapped() {
        isLocationDenied = true
        selectedPage = .search
    }
    
    // MARK: - Private Functions
    
    private func fetchLocationsAroundMe(userLocation: CLLocation) {
        Task {
            let result = try? await aroundNetworkManager.fetchLocationsAround(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            // запрос локаций из сети!!! и обновление Core DATA
            print(result)
        }
    }
}
