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
    
    //MARK: - Inits
    
    init(country: Country,
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.country = country
        self.networkManager = networkManager
        self.dataManager = dataManager
        loadImage()
        getCountry(id: country.id)
    }
    
}

extension CountryViewModel {
    
    //MARK: - Private Functions
    
    private func getCountry(id: Int16) {
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
    private func getCountryFromDB() async {
        let result = await dataManager.getCountry(id: country.objectID)
        switch result {
        case .success(let country):
            withAnimation(.spring()) {
                self.country = country
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
                let result = try await networkManager.fetchCountry(countryId: Int(country.id))
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                if let decodedCountry = result.country {
                    country.about = decodedCountry.about
                    country.flag = decodedCountry.flag
                    country.name = decodedCountry.name
                    country.photo = decodedCountry.photo
                    country.smallDescriprion = await dataManager.createSmallDescriprion(decription: decodedCountry.about)
                    country.isActive = decodedCountry.isActive == 1 ? true : false
                    if let decodedRegions = decodedCountry.regions {
                        if let regions = country.regions?.allObjects as? [Region] {
                            for decodedRegion in decodedRegions {
                                if let region = regions.first(where: { $0.id == Int16(decodedRegion.id) } ) {
                                    region.name = decodedRegion.name
                                    region.isActive = decodedRegion.isActive == 1 ? true : false
                                    if let cities = region.cities?.allObjects as? [City] {
                                        if let decodedCities = decodedRegion.cities {
                                            for decodedCity in decodedCities {
                                                if let city = cities.first(where: { $0.id == Int16(decodedCity.id) } ) {
                                                    city.name = decodedCity.name
                                                    city.isActive = decodedCity.isActive == 1 ? true : false
                                                } else {
                                                    let city = await dataManager.createCity(decodedCity: decodedCity)
                                                    region.addToCities(city)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    let region = await dataManager.createRegion(decodedRegion: decodedRegion)
                                    self.country.addToRegions(region)

                                }
                                
                            }
                        }
                    }
                    await dataManager.save()
                    await getCountryFromDB()
                }
            }catch {
                    
                    //TODO
                    
                    print("Error fetching country ->>>>>>>>>>> \(error)")
                }
            }
        }
    }
