//
//  CitiesViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

final class CitiesViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var cities: [City] = []
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    //MARK: - Inits
    
    init(cities: [City],
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.cities = cities
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
}

extension CitiesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchCountry() {
        Task {
            do {
                let result = try await networkManager.fetchCountry(countryId: Int(country.id))
                
                if let error = result.error {
                    
                    //TODO
                    print(error)
                    return
                    
                }
                
                if let decodedCountry = result.country {

                    
                    if let decodedCities = decodedCountry.cities {
                        for decodedCity in decodedCities {
                            
                            //                                @FetchRequest(
                            //                                    sortDescriptors: [SortDescriptor(\.name)],
                            //                                    predicate: NSPredicate(format: "name == %@", "Python")
                            //                                ) var languages: FetchedResults<ProgrammingLanguage>
                            
                            //                                (country.cities_relationship?.allObjects as? [City])?.first(where: <#T##(City) throws -> Bool#>)
                            
                            
                            let citiesArray = country.cities_relationship?.allObjects as? [City]
                            
                            if let city = citiesArray?.first(where: { $0.id == decodedCity.id } ) {
                                city.name = decodedCity.name
                                city.regionId = Int16(decodedCity.regionId)
                                city.regionName = decodedCity.regionName
                                city.isActive = decodedCity.isActive == 1 ? true : false
                            } else {
                                let newCountry = await dataManager.createCity(decodedCity: decodedCity)
                                country.addToCities_relationship(newCountry)
                            }
                            await dataManager.save()
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
