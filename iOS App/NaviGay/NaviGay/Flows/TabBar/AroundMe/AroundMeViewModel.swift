//
//  AroundMeViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import SwiftUI

enum AroundMeRouter {
    case home
    case map
}

final class AroundMeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    var locationManager: LocationManagerProtocol
    let dataManager: MapDataManagerProtocol

    // MARK: - Inits
    
    init(locationManager: LocationManagerProtocol, dataManager: MapDataManagerProtocol) {
        self.locationManager = locationManager
        self.dataManager = dataManager
    }
}
