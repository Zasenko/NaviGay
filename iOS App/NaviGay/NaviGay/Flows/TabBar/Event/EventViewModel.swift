//
//  EventViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.05.23.
//

import SwiftUI

final class EventViewModel: ObservableObject {
    //MARK: - Properties
    
    @Published var event: Event
    @Published var eventImage: Image = AppImages.bw
    
    let networkManager: EventNetworkManagerProtocol
    let dataManager: EventDataManagerProtocol
    
    //MARK: - Inits
    
    init(event: Event,
         networkManager: EventNetworkManagerProtocol,
         dataManager: EventDataManagerProtocol) {
        self.event = event
        self.networkManager = networkManager
        self.dataManager = dataManager
//        loadImage()
//        getPlace()
    }
}
