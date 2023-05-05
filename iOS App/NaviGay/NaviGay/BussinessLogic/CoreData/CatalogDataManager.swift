//
//  CountryDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import CoreData

protocol CatalogDataManagerProtocol {
    func getCountries() async -> Result<[Country], Error>
    func createCountry(decodedCountry: DecodedCountry) async -> Country
    func save() async
}

final class CatalogDataManager {
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}

// MARK: - UserDataManagerProtocol
extension CatalogDataManager: CatalogDataManagerProtocol {
    
    func getCountries() async -> Result<[Country], Error> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        let sort = NSSortDescriptor(keyPath: \Country.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            let countries = try self.manager.context.fetch(request)//.filter { $0.isActive == true }
            return .success(countries)
        } catch let error {
            return.failure(error)
        }
    }
    
    func createCountry(decodedCountry: DecodedCountry) async -> Country {
        let newCountry = Country(context: manager.context)
        newCountry.id = Int16(decodedCountry.id)
        newCountry.about = decodedCountry.about
        newCountry.flag = decodedCountry.flag
        newCountry.name = decodedCountry.name
        newCountry.photo = decodedCountry.photo
        newCountry.isActive = decodedCountry.isActive == 1 ? true : false
        return newCountry
    }
    
    func save() async {
        manager.saveData()
    }
}
