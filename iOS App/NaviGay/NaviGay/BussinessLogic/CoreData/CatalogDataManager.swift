//
//  CountryDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import CoreData

protocol CatalogDataManagerProtocol {
    func getCountries() async -> Result<[Country], Error>
    func getCountry(id: Int16) async -> Result<Country, Error>
    func createCountry(decodedCountry: DecodedCountry) async -> Country
    func createRegion(decodedRegion: DecodedRegion) async -> Region
    func createCity(decodedCity: DecodedCity) async -> City
    func save() async
    func createSmallDescriprion(decription: String) async -> String?
}

final class CatalogDataManager {
    
    enum CatalogDataManagerErrors: Error {
        case noCountry
    }
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}

// MARK: - UserDataManagerProtocol
extension CatalogDataManager: CatalogDataManagerProtocol {
    
    func save() async {
        manager.saveData()
    }
    
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
    
    func getCountry(id: Int16) async -> Result<Country, Error> {
        
        let request = NSFetchRequest<Country>(entityName: "Country")
        request.predicate = NSPredicate(format: "id = %@", String(id))
        
        do {
            guard let country = try self.manager.context.fetch(request).first else {
                return.failure(CatalogDataManagerErrors.noCountry)
            }
            return .success(country)
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
        newCountry.smallDescriprion = await createSmallDescriprion(decription: decodedCountry.about)
        return newCountry
    }
    
    func createRegion(decodedRegion: DecodedRegion) async -> Region {
        let newRegion = Region(context: manager.context)
        newRegion.id = Int16(decodedRegion.id)
        newRegion.name = decodedRegion.name
        newRegion.isActive = decodedRegion.isActive == 1 ? true : false
        
        if let decodedCities = decodedRegion.cities {
            for decodedCity in decodedCities {
                let newCity = await createCity(decodedCity: decodedCity)
                newRegion.addToCities(newCity)
            }
        }
        return newRegion
    }
    
    func createCity(decodedCity: DecodedCity) async -> City {
        let newCity = City(context: manager.context)
        newCity.id = Int16(decodedCity.id)
        newCity.name = decodedCity.name
        newCity.isActive = decodedCity.isActive == 1 ? true : false
        return newCity
    }
    
    func createSmallDescriprion(decription: String) async -> String? {
        if let description = decription.split(separator: ".").first {
            return "\(description)."
        } else {
            return nil
        }
    }
}
