//
//  CityPlaceViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.05.23.
//

import SwiftUI

final class CityPlaceViewModel: ObservableObject {
        
    //MARK: - Properties
    
    @Published var place: Place
    @Published var placeImage: Image = AppImages.appIcon
    
    let dataManager: CoreDataManagerProtocol
    
    //MARK: - Inits
    
    init(place: Place, dataManager: CoreDataManagerProtocol) {
        self.place = place
        self.dataManager = dataManager
        loadImage()
    }
}

extension CityPlaceViewModel {
    
    //MARK: - Functions
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = place.photo else { return }
        do {
            self.placeImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            
            //TODO
            
            print(error.localizedDescription)
        }
    }
}
