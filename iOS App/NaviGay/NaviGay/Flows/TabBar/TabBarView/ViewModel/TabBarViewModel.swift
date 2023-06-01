//
//  TabBarViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

enum TabBarRouter {
    case catalog
    case map
    case home
    case user
}

final class TabBarViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedPage: TabBarRouter = TabBarRouter.catalog
    
    @Binding var isUserLogin: Bool
    
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
    
    private lazy var catalogNetworkManager = CatalogNetworkManager()
    private lazy var catalogDataManager = CatalogDataManager(manager: dataManager)
    
    // MARK: - Inits
    
    init(isUserLogin: Binding<Bool>, dataManager: CoreDataManagerProtocol) {
        self._isUserLogin = isUserLogin
        self.dataManager = dataManager
    }
}