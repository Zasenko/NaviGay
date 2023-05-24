//
//  CountryViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

final class CountryViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var country: Country
    @Published var countryImage: Image = AppImages.appIcon
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    let tESTdataManager: CoreDataManagerProtocol
    
    //MARK: - Inits
    
    init(country: Country,
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol, tESTdataManager: CoreDataManagerProtocol) {
        self.country = country
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.tESTdataManager = tESTdataManager
        loadImage()
        getCountry()
    }
}

extension CountryViewModel {
    
    //MARK: - Private Functions
    
    private func getCountry() {
        Task {
            await fetchCountry()
        }
    }
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = country.photo else { return }
        do {
            self.countryImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            
            //TODO
            
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func reloadCountry() async {
        let result = await dataManager.getCountry(id: country.objectID)
        switch result {
        case .success(let country):
            if let country = country {
                withAnimation(.spring()) {
                    self.country = country
                  //  print("CountryViewModel getCountryFromDB()  success country id: \(country.id)")
                }
            } else {
              //  print("---- NoCountry ------")
            }
        case .failure(let error):
            // TODO
            print("CountryViewModel getCountryFromDB() failure ->>>>>>>>>>> ", error)
        }
    }
    
    
    @MainActor
    private func fetchCountry() {
        Task {
            do {
              //  print("fetchCountry()")
                let result = try await networkManager.fetchCountry(countryId: Int(country.id))
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                if let decodedCountry = result.country {
                 //   print("fetchCountry() - decodedCountry id:", decodedCountry.id)
                    country.about = decodedCountry.about
                    country.flag = decodedCountry.flag
                    country.name = decodedCountry.name
                    country.photo = decodedCountry.photo
                    country.isActive = decodedCountry.isActive == 1 ? true : false
                    
                    if let decodedRegions = decodedCountry.regions {
                        if let regions = country.regions?.allObjects as? [Region] {
                            for decodedRegion in decodedRegions {
                               // print("fetchCountry() - decodedRegion id: ", decodedRegion.id)
                                let region = regions.first(where: { $0.id == decodedRegion.id } )
                                if region != nil {
                                    region?.name = decodedRegion.name
                                    region?.isActive = decodedRegion.isActive == 1 ? true : false
                                    
                                    if let cities = region?.cities?.allObjects as? [City] {
                                        
                                        if let decodedCities = decodedRegion.cities {
                                            for decodedCity in decodedCities {
                                             //   print("fetchCountry() - decodedCity id :", decodedCity.id)
                                                if let city = cities.first(where: { $0.id == decodedCity.id } ) {
                                                 //   print("fetchCountry() - city id: ", city.id)
                                                    city.name = decodedCity.name
                                                    city.photo = decodedCity.photo
                                                    city.isActive = decodedCity.isActive == 1 ? true : false
                                                 //   print("fetchCountry() - city changed id: ", city.id)
                                                } else {
                                                  //  print("fetchCountry() - NEW decodedCity id:", decodedCity.id)
                                                    let city = await dataManager.createCity(decodedCity: decodedCity)
                                                    region?.addToCities(city)
                                                   // print("fetchCountry() - NEW decodedCity added to region cityID: ", city.id)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                   // print("fetchCountry() - NEW region")
                                    let newRegion = await dataManager.createRegion(decodedRegion: decodedRegion)

                                        if let decodedCities = decodedRegion.cities {
                                            for decodedCity in decodedCities {
                                               // print("fetchCountry() - decodedCity id :", decodedCity.id)
                                                switch await dataManager.findCity(id: decodedCity.id) {
                                                case .success(let city):
                                                    if let city = city {
                                                      //  print("fetchCountry() - findCity city id :", city.id)
                                                        city.name = decodedCity.name
                                                        city.photo = decodedCity.photo
                                                        city.isActive = decodedCity.isActive == 1 ? true : false
                                                      //  print("fetchCountry() - findCity city changed id :", city.id)
                                                        newRegion.addToCities(city)
                                                     //   print("fetchCountry() - findCity city add to new Region , city id :", city.id)
                                                    } else {
                                                      //  print("------- 222 no city ---------")
                                                      //  print("fetchCountry() - NEW decodedCity id:", decodedCity.id)
                                                        let city = await dataManager.createCity(decodedCity: decodedCity)
                                                     //   print("fetchCountry() - new City created city id :", city.id)
                                                        newRegion.addToCities(city)
                                                 //       print("fetchCountry() - NEW decodedCity added to region cityID: ", city.id)
                                                    }
                                                case .failure(let error):
                                                    print("fetchCountry() - findCity failure :", error)
                                                }
                                            }
                                        }
                                    
                                    
                                    self.country.addToRegions(newRegion)
                                 //   print("fetchCountry() - region = NEW region id: ", newRegion.id)
                                }
                            }
                        }
                    }
                    
                 //   print("fetchCountry() - FINAL save")
                    dataManager.save() { [weak self] result in
                       // print("fetchCountry() -  FINAL saved")
                        if result {
                           // print("---- result FINAL saved -------", result)
                            Task {
                                await self?.reloadCountry()
                            }
                        }
                    }
                }
            } catch {
                
                //TODO
                
                print("Error fetching country ->>>>>>>>>>> \(error)")
            }
        }
    }
}
