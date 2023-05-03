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
    
//    @Binding var isUserHaveLocation: Bool
//    //let viewBilder: ViewBilder
//
//    private let networkManager: AuthNetworkManagerProtocol
//
//    // MARK: - Inits
//    init(isUserLoggedIn: Binding<Bool>, isUserHaveLocation: Binding<Bool>, networkManager: AuthNetworkManagerProtocol) {
//        self._isUserLoggedIn = isUserLoggedIn
//        self._isUserHaveLocation = isUserHaveLocation
//     //   self.viewBilder = viewBilder
//        self.networkManager = networkManager
//        createTabbar()
//    }
    init(isUserLogin: Binding<Bool>) {
        self._isUserLogin = isUserLogin
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
                         view: AnyView(Color.red)),
            TabBarButton(id: 2,
                         title: "Calendar",
                         img: AppImages.iconCalendar,
                         view: AnyView(Color.orange)),
            TabBarButton(id: 3,
                         title: "Search",
                         img: AppImages.iconSearch,
                         view: AnyView(Color.gray)),
            TabBarButton(id: 4,
                         title: "User",
                         img: AppImages.iconPerson,
                         view: AnyView(UserView(vm: UserViewModel(isUserLogin: $isUserLogin))))
        ]
    }
}
