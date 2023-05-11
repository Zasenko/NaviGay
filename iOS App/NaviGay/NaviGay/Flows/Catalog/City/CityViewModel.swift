//
//  CityViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 11.05.23.
//

import SwiftUI

final class CityViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var city: City
    
    let networkManager: CatalogNetworkManagerProtocol
    let dataManager: CatalogDataManagerProtocol
    
    //MARK: - Inits
    
    init(city: City,
         networkManager: CatalogNetworkManagerProtocol,
         dataManager: CatalogDataManagerProtocol) {
        self.city = city
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.getCity(id: city.id)
    }
}

extension CityViewModel {
    
    //MARK: - Functions
    
    func getCity(id: Int16) {
        Task {
            await getCityFromDB(id: id)
            await fetchCity(id: id)
        }
    }
    
    //MARK: - Private Functions
    
    @MainActor
    private func getCityFromDB(id: Int16) async {
        let result = await dataManager.getCity(id: id)
        switch result {
        case .success(let city):
            withAnimation(.spring()) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.city = city
                }
            }
        case .failure(let error):
            // TODO
            print("getCountriesFromDB() failure ->>>>>>>>>>> ", error)
        }
    }
    
    @MainActor
    private func fetchCity(id: Int16) {
        Task {
            do {
                let result = try await networkManager.fetchCity(id: Int(id))
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
                    await dataManager.save()
                    await getCityFromDB(id: city.id)
                }
            }catch {
                    
                    //TODO
                    
                    print("Error fetching city ->>>>>>>>>>> \(error)")
                }
            }
        }
}
