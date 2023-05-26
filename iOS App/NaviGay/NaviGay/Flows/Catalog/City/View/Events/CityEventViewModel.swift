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
    @Published var startTime: String = "startTime"
    @Published var finishTime: String = "finishTime"
    @Published var isPartyFinished: Bool = false
    //MARK: - Inits
    
    init(event: Event) {
        self.event = event
        loadImage()
        
//        //TODO!!!!!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
//        let nowString: String = dateFormatter.string(from: Date.now)
//        print("nowString ", nowString)
//
//
//
//
//        print("------------------------")
//        print("nowString: ", nowString)
//
//        guard let nowDate = dateFormatter.date(from: nowString) else {
//            return
//
//        }
//        print("Date nowDate: ", nowDate)
//
        if let startTime = event.startTime {
            self.startTime = dateFormatter.string(from: startTime)
        }
        
        if let finishTime = event.finishTime {
            
            self.finishTime = dateFormatter.string(from: finishTime)
//
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let fdate: String = dateFormatter.string(from: finishTime)
//            let ndate: String = dateFormatter.string(from: Date.now)
//
//            let f = dateFormatter.date(from: fdate)!
//            let n = dateFormatter.date(from: ndate)!
            
//            print("Date finishTime.formatted(): ", finishTime.formatted())
//            print("Date.now.formatted(): ", Date.now.formatted())
//
//
//            print("Date finishTime: ", finishTime)
//
//            print("Date.now: ", Date.now)
//
//            print("------------------------")
            switch Calendar.current.compare(finishTime, to: Date.now, toGranularity: .hour) {
            case .orderedAscending, .orderedSame:
                isPartyFinished = true
            case .orderedDescending:
                break
            }
        }
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
