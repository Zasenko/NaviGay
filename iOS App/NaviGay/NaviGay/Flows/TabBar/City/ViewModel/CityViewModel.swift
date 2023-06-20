//
//  CityViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 11.05.23.
//

import SwiftUI
import Combine

final class CityViewModel: ObservableObject {
    
    
    //MARK: - Properties
    
    @Published var city: City
    @Published var cityImage: Image = AppImages.bw

    @Published var sortedDictionary: [String: [Place]] = [:]
    @Published var sortedKeys: [String] = []
    
    @Published var events: [Event] = []
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    //MARK: - Inits
    
    init(city: City,
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.city = city
        self.networkManager = networkManager
        self.dataManager = dataManager
        
        if let events = city.events?.allObjects as? [Event] {
            self.events = events
//            print("------------")
//            print(events)
//            print("------------")
        }
        if let places = city.places?.allObjects as? [Place] {
            Task {
                await updateSortedDictionary(with: places)
            }
        }
        
        loadImage()
        getCity()
    }
}

extension CityViewModel {
    
    @MainActor
    private func updateSortedDictionary(with places: [Place]) {
        sortedDictionary = Dictionary(grouping: places, by: { $0.type ?? "all places" })
        sortedKeys = sortedDictionary.keys.sorted()
    }
    
    //MARK: - Private Functions
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    private func getCity() {
        Task {
            await fetchCity()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = city.photo else { return }
        do {
            self.cityImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            //TODO
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func getCityFromDB() async {
        let result = await dataManager.getCity(id: city.objectID)
        switch result {
        case .success(let city):
            if let city = city {
                withAnimation(.spring()) {
                    self.city = city
                    if let events = city.events?.allObjects as? [Event] {
                        self.events = events
//                        print("------------")
//                        print(events)
//                        print("------------")
                    }
                    if let places = city.places?.allObjects as? [Place] {
                             updateSortedDictionary(with: places)
                    }
                    
                }
            } else {
                //   print("---- NoCity ------")
            }
        case .failure(let error):
            // TODO
            print("CityViewModel getCityFromDB() failure ->>>>>>>>>>> ", error)
        }
    }
    
    @MainActor
    private func fetchCity() {
        Task {
            do {
                let result = try await self.networkManager.fetchCity(id: Int(city.id))
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                guard  let decodedCity = result.city else {return}
                city.about = decodedCity.about
                city.name = decodedCity.name
                city.photo = decodedCity.photo
                city.isActive = decodedCity.isActive == 1 ? true : false
                if let decodedPlaces = decodedCity.places {
                    if let places = city.places?.allObjects as? [Place] {
                        for decodedPlace in decodedPlaces {
                            if let place = places.first(where: { $0.id == decodedPlace.id } ) {
                                place.name = decodedPlace.name
                                place.type = decodedPlace.type
                                place.photo = decodedPlace.photo
                                place.address = decodedPlace.address
                                place.latitude = decodedPlace.latitude
                                place.longitude = decodedPlace.longitude
                                place.isActive = decodedPlace.isActive == 1 ? true : false
                                place.isChecked = decodedPlace.isChecked == 1 ? true : false
                                if let tags = place.tags?.allObjects as? [Tag] {
                                    for tag in tags {
                                        place.removeFromTags(tag)
                                    }
                                }
                                for decodedTag in decodedPlace.tags {
                                    switch await dataManager.findTag(tag: decodedTag) {
                                    case .success(let tag):
                                        if let tag = tag {
                                            place.addToTags(tag)
                                        } else {
                                            let tag = await dataManager.createTag(tag: decodedTag)
                                            place.addToTags(tag)
                                        }
                                    case .failure(let error):
                                        //TODO
                                        print("fetchCountry() - findCity failure :", error)
                                    }
                                }
                            } else {
                                switch await dataManager.findPlace(id: decodedPlace.id) {
                                case .success(let place):
                                    if let place = place {
                                        
                                        place.name = decodedPlace.name
                                        place.type = decodedPlace.type
                                        place.photo = decodedPlace.photo
                                        place.address = decodedPlace.address
                                        place.latitude = decodedPlace.latitude
                                        place.longitude = decodedPlace.longitude
                                        place.isActive = decodedPlace.isActive == 1 ? true : false
                                        place.isChecked = decodedPlace.isChecked == 1 ? true : false
                                        
                                        if let tags = place.tags?.allObjects as? [Tag] {
                                            for tag in tags {
                                                place.removeFromTags(tag)
                                            }
                                        }
                                        for decodedTag in decodedPlace.tags {
                                            
                                            switch await dataManager.findTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    place.addToTags(tag)
                                                } else {
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    place.addToTags(tag)
                                                }
                                            case .failure(let error):
                                                print("fetchCountry() - findCity failure :", error)
                                            }
                                            
                                        }
                                        self.city.addToPlaces(place)
                                    } else {
                                        let place = await dataManager.createPlace(decodedPlace: decodedPlace)
                                        
                                        place.name = decodedPlace.name
                                        place.type = decodedPlace.type
                                        place.photo = decodedPlace.photo
                                        place.address = decodedPlace.address
                                        place.latitude = decodedPlace.latitude
                                        place.longitude = decodedPlace.longitude
                                        place.isActive = decodedPlace.isActive == 1 ? true : false
                                        place.isChecked = decodedPlace.isChecked == 1 ? true : false
                                        
                                        for decodedTag in decodedPlace.tags {
                                            
                                            switch await dataManager.findTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    place.addToTags(tag)
                                                } else {
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    place.addToTags(tag)
                                                }
                                            case .failure(let error):
                                                print("fetchCountry() - findPlaceTag failure :", error)
                                            }
                                        }
                                        
                                        self.city.addToPlaces(place)
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    }
                }
                
                
                self.events = []
                
                if let decodedEvents = decodedCity.events {
                    if let events = city.events?.allObjects as? [Event] {
                        for decodedEvent in decodedEvents {
                            if let event = events.first(where: { $0.id == decodedEvent.id } ) {
                                event.name = decodedEvent.name
                                event.type = decodedEvent.type
                                event.cover = decodedEvent.cover
                                event.address = decodedEvent.address
                                event.latitude = decodedEvent.latitude
                                event.longitude = decodedEvent.longitude
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                               // dateFormatter.timeZone = .gmt
                                dateFormatter.timeZone = TimeZone.current
                                event.startTime = dateFormatter.date(from: decodedEvent.startTime)
                                event.finishTime = dateFormatter.date(from: decodedEvent.finishTime)
//                                print("------------")
//                                print(event.startTime ?? "-")
//                                print(event.finishTime ?? "-")
//                                print("------------")
                                event.isActive = decodedEvent.isActive == 1 ? true : false
                                event.isChecked = decodedEvent.isChecked == 1 ? true : false
                                
                                if let tags = event.tags?.allObjects as? [Tag] {
                                    for tag in tags {
                                        event.removeFromTags(tag)
                                    }
                                }
                                
                                for decodedTag in decodedEvent.tags {
                                    switch await dataManager.findTag(tag: decodedTag) {
                                    case .success(let tag):
                                        if let tag = tag {
                                            event.addToTags(tag)
                                        } else {
                                            let tag = await dataManager.createTag(tag: decodedTag)
                                            event.addToTags(tag)
                                        }
                                    case .failure(let error):
                                        //TODO
                                        print("fetchCountry() - findCity failure :", error)
                                    }
                                }
                                
                            //    self.events.append(contentsOf: events)
                                
                            } else {
                                switch await dataManager.findEvent(id: decodedEvent.id) {
                                case .success(let event):
                                    if let event = event {
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                            .dateStyle = .medium
//                                            .timeStyle = .medium
                                        dateFormatter.timeZone = TimeZone.current
                                        event.startTime = dateFormatter.date(from: decodedEvent.startTime)
                                        event.finishTime = dateFormatter.date(from: decodedEvent.finishTime)
                                        
                                        for decodedTag in decodedEvent.tags {
                                            switch await dataManager.findTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    event.addToTags(tag)
                                                } else {
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    event.addToTags(tag)
                                                }
                                            case .failure(let error):
                                                //TODO
                                                print("fetchCountry() - findCity failure :", error)
                                            }
                                        }
                                        self.city.addToEvents(event)
                               //         self.events.append(event)
                                    } else {
                                        let event = await dataManager.createEvent(decodedEvent: decodedEvent)
                                        for decodedTag in decodedEvent.tags {
                                            
                                            switch await dataManager.findTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    event.addToTags(tag)
                                                } else {
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    event.addToTags(tag)
                                                }
                                            case .failure(let error):
                                                //TODO
                                                print("fetchCountry() - findPlaceTag failure :", error)
                                            }
                                        }
                                        self.city.addToEvents(event)
                               //         self.events.append(event)
                                    }
                                case .failure(let error):
                                    //TODO
                                    print(error)
                                }
                            }
                        }
                    }
                }
                dataManager.save { [weak self] result in
                    if result {
                        Task {
                            await self?.getCityFromDB()
                        }
                    } else {
                        //TODO
                        print("Error caving city ->>>>>>>>>>>")
                    }
                }
            } catch {
                //TODO
                print("Error fetching city ->>>>>>>>>>> \(error)")
            }
        }
    }
}
