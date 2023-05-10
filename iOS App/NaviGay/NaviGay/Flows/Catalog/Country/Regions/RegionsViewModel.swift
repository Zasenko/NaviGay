//
//  RegionsViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

final class RegionsViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var regions: [Region] = []
    
   // let networkManager: CatalogNetworkManagerProtocol
   // let dataManager: CatalogDataManagerProtocol
    
    //MARK: - Inits
    
    init(regions: [Region],
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.regions = regions
    }
    
}

extension RegionsViewModel {
}
