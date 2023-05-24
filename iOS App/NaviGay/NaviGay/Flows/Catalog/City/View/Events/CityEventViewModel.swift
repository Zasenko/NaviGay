//
//  CityEventViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import SwiftUI

final class CityEventViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var event: Event
    @Published var eventImage: Image = AppImages.appIcon
    @Published var eventStart: String = ""
    
    //MARK: - Inits
    
    init(event: Event) {
        self.event = event
        loadImage()
        
        print(event.startTime ?? "--------")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .gmt
        
        if let time = event.startTime {
            eventStart = dateFormatter.string(from: time)
        }
        
        
        print("start -> ", eventStart)
    }
}

extension CityEventViewModel {
    
    //MARK: - Functions
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = event.cover else { return }
        do {
            self.eventImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            
            //TODO
            
            print(error.localizedDescription)
        }
    }
}
