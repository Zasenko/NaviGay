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
    @Published var cityImage: Image = AppImages.appIcon
    
    @Published var placesGroupedByType: [(key: String, value: [Place])] = []
    
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    //MARK: - Inits
    
    init(city: City,
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.city = city
        self.networkManager = networkManager
        self.dataManager = dataManager
        loadImage()
        getCity()
    }
}

extension CityViewModel {
    
    //MARK: - Functions
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
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
    
    func getCity() {
        Task {
            await fetchCity()
        }
    }
    
    //MARK: - Private Functions
    
    @MainActor
    private func getCityFromDB() async {
        let result = await dataManager.getCity(id: city.objectID)
        switch result {
        case .success(let city):
            if let city = city {
                withAnimation(.spring()) {
                    self.city = city
                    if let places = city.places?.allObjects as? [Place] {
                        self.placesGroupedByType = groupPlacesByType(places)
                    }
                }
            } else {
                print("---- NoCity ------")
            }
        case .failure(let error):
            // TODO
            print("CityViewModel getCityFromDB() failure ->>>>>>>>>>> ", error)
        }
    }
    
    @MainActor
    private func fetchCity() {
        print("fetchCity")
        Task {
            do {
                let result = try await self.networkManager.fetchCity(id: Int(city.id))
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                if let decodedCity = result.city {
                    city.about = decodedCity.about
                    city.name = decodedCity.name
                    city.photo = decodedCity.photo
                    city.isActive = decodedCity.isActive == 1 ? true : false
                    if let decodedPlaces = decodedCity.places {
                        if let places = city.places?.allObjects as? [Place] {
                            for decodedPlace in decodedPlaces {
                                if let place = places.first(where: { $0.id == decodedPlace.id } ) {
                                    place.name = decodedPlace.name
                                    place.type = decodedPlace.type.rawValue
                                    place.photo = decodedPlace.photo
                                    place.address = decodedPlace.address
                                    place.latitude = decodedPlace.latitude
                                    place.longitude = decodedPlace.longitude
                                    place.isActive = decodedPlace.isActive == 1 ? true : false
                                    place.isChecked = decodedPlace.isChecked == 1 ? true : false
                                    
                                    if let tags = place.tags?.allObjects as? [PlaceTag] {
                                        for tag in tags {
                                            place.removeFromTags(tag)
                                        }
                                    }
                                    
                                    if let decodedTags = decodedPlace.tags {
                                        
                                        for decodedTag in decodedTags {
                                            switch await dataManager.findPlaceTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    place.addToTags(tag)
                                                    print("fetchCountry() - findCity city add to new Region , city id :", city.id)
                                                } else {
                                                    print("------- 222 no tag ---------")
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    place.addToTags(tag)
                                                    print("fetchCountry() -createTag created tag id :", tag.id)
                                                }
                                            case .failure(let error):
                                                print("fetchCountry() - findCity failure :", error)
                                            }
                                            
                                        }
                                    }
                                    //                                    if let workingTimes = place.workingTimes?.allObjects as? [WorkingTime] {
                                    //                                        for workingTime in workingTimes {
                                    //                                            place.removeFromWorkingTimes(workingTime)
                                    //                                        }
                                    //                                    }
                                    
                                } else {
                                    let place = await dataManager.createPlace(decodedPlace: decodedPlace)
                                    if let decodedTags = decodedPlace.tags {
                                        for decodedTag in decodedTags {
                                            
                                            switch await dataManager.findPlaceTag(tag: decodedTag) {
                                            case .success(let tag):
                                                if let tag = tag {
                                                    place.addToTags(tag)
                                                    print("fetchCountry() - findCity city add to new Region , city id :", city.id)
                                                } else {
                                                    print("------- 222 no tag ---------")
                                                    let tag = await dataManager.createTag(tag: decodedTag)
                                                    place.addToTags(tag)
                                                    print("fetchCountry() -createTag created tag id :", tag.id)
                                                }
                                            case .failure(let error):
                                                print("fetchCountry() - findCity failure :", error)
                                            }
                                        }
                                    }
                                    self.city.addToPlaces(place)
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
                            print("Error caving city ->>>>>>>>>>>")
                        }
                    }
                }
            } catch {
                
                //TODO
                
                print("Error fetching city ->>>>>>>>>>> \(error)")
            }
        }
    }
    
    private func groupPlacesByType(_ places: [Place]) -> [(key: String, value: [Place])] {
        let groupedPlaces = Dictionary(grouping: places, by: { $0.type ?? "" })
        let sortedGroups = groupedPlaces.sorted(by: { $0.key < $1.key })
        return sortedGroups
    }
}
