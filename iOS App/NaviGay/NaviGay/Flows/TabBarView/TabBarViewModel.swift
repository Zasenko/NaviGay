//
//  TabBarViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

final class TabBarViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var items: [TabBarButton] = []
    @Published var selectedItem = 0
    @Binding var isUserLogin: Bool

    // MARK: - Private Properties
    
    private let networkMonitor: NetworkMonitor
    private let api: ApiProperties
    private let dataManager: CoreDataManagerProtocol
    
    private lazy var catalogNetworkManager = CatalogNetworkManager(networkMonitor: networkMonitor, api: api)
    private lazy var catalogDataManager = CatalogDataManager(manager: dataManager)
    
    // MARK: - Inits
    
    init(isUserLogin: Binding<Bool>, networkMonitor: NetworkMonitor, api: ApiProperties, dataManager: CoreDataManagerProtocol) {
        self._isUserLogin = isUserLogin
        self.networkMonitor = networkMonitor
        self.dataManager = dataManager
        self.api = api
        createTabbar()
    }
}

extension TabBarViewModel {
    
    // MARK: - Functios
    
    func buttonTappde(index: Int) {
        selectedItem = index
    }

    // MARK: - Private Functions
    
    private func createTabbar() {
        
        items = [
            TabBarButton(id: 1,
                         title: "Map",
                         img: AppImages.iconMap,
                         view: AnyView(Color.red)
                        ),
            TabBarButton(id: 2,
                         title: "Calendar",
                         img: AppImages.iconCalendar,
                         view: AnyView(Color.orange)
                        ),
            TabBarButton(id: 3,
                         title: "Catalog",
                         img: AppImages.iconSearch,
                         view: AnyView(CatalogView(viewModel: CatalogViewModel(networkManager: self.catalogNetworkManager, dataManager: self.catalogDataManager)))
                        ),
            TabBarButton(id: 4,
                         title: "User",
                         img: AppImages.iconPerson,
                         view: AnyView(UserView(vm: UserViewModel(isUserLogin: $isUserLogin)))
                        )
        ]
    }
}
