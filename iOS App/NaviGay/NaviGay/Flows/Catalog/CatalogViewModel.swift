//
//  CatalogViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import SwiftUI

final class CatalogViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var countries: [Country] = []
    @Published var activeCountries: [Country] = []
    
    @Published var loadState: LoadState = .normal
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    let safeArea: EdgeInsets
    let size: CGSize
    
    //MARK: - Inits
    
    init(networkManager: CatalogNetworkManagerProtocol, dataManager: CatalogDataManagerProtocol, safeArea: EdgeInsets, size: CGSize) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.safeArea = safeArea
        self.size = size
        getCountries()
    }
    
}

extension CatalogViewModel {
    
    //MARK: - Functions
    func getCountries() {
        Task {
            await self.getCountriesFromDB()
            await self.fetchCountries()
        }
    }
    
    func cteateCountryView(country: Country) -> AnyView {
        print("CatalogViewModel - cteateCountryView, country id \(country.id)")
        return AnyView(CountryView(viewModel: CountryViewModel(country: country, networkManager: self.networkManager, dataManager: self.dataManager), safeArea: safeArea, size: size))
    }

    
    //MARK: - Private Functions
    
    @MainActor
    private func getCountriesFromDB() async {
        let result = await dataManager.getCountries()
        switch result {
        case .success(let countries):
            withAnimation(.spring()) {
                if countries.isEmpty {
                    loadState = .loading
                } else {
                    self.countries = countries
                    self.activeCountries = countries.filter(( { $0.isActive == true} ))
                }
            }
        case .failure(let error):
            
            // TODO
            print("CatalogViewModel getCountriesFromDB() failure ->>>>>>>>>>> ", error.localizedDescription)
        }
    }
    
    @MainActor
    private func fetchCountries() async {
        Task {
            do {
                let result = try await networkManager.fetchCountries()
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                if let decodedCountries = result.countries {
                    for decodedCountry in decodedCountries {
                        if let country = countries.first(where: { $0.id == Int16(decodedCountry.id)}) {
                            country.about = decodedCountry.about
                            country.flag = decodedCountry.flag
                            country.name = decodedCountry.name
                            country.photo = decodedCountry.photo
                            country.smallDescriprion = await dataManager.createSmallDescriprion(decription: decodedCountry.about)
                            country.isActive = decodedCountry.isActive == 1 ? true : false
                        } else {
                            let newCountry = await dataManager.createCountry(decodedCountry: decodedCountry)
                            self.countries.append(newCountry)

                        }
                    }
                    await dataManager.save()
                    await getCountriesFromDB()
                }
                withAnimation(.spring()) {
                    loadState = .normal
                }
            } catch {
                
                //TODO
                
                print("Error fetching country ->>>>>>>>>>> \(error)")
            }
        }
    }
}
