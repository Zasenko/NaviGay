//
//  CountryDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import CoreData

protocol CatalogDataManagerProtocol {
    func getCountries() async -> Result<[Country], Error>
    func getCountry(id: NSManagedObjectID) async -> Result<Country?, Error>
    func getCity(id: NSManagedObjectID) async -> Result<City?, Error>
    
    func createCountry(decodedCountry: DecodedCountry) async -> Country
    func createRegion(decodedRegion: DecodedRegion) async -> Region
    func createCity(decodedCity: DecodedCity) async -> City
    func createPlace(decodedPlace: DecodedPlace)  async -> Place
    func createEvent(decodedEvent: DecodedEvent)  async -> Event
    func createTag(tag: String) async -> Tag
    
    func findCity(id: Int) async -> Result<City?, Error>
    func findPlace(id: Int) async -> Result<Place?, Error>
    func findEvent(id: Int) async -> Result<Event?, Error>
    func findTag(tag: String) async -> Result<Tag?, Error>
    
    func save(complition: @escaping( (Bool) -> Void ))
}

enum CatalogDataManagerErrors: Error {
    case noCountry, noCity
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
    
    func save(complition: @escaping( (Bool) -> Void )) {
        manager.saveData { result in
            if result {
                complition(true)
            } else {
                complition(false)
            }
        }
    }
    
    func getCountries() async -> Result<[Country], Error> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        let sort = NSSortDescriptor(keyPath: \Country.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            let countries = try self.manager.context.fetch(request)
            return .success(countries)
        } catch let error {
            return.failure(error)
        }
    }
    
    func getCountry(id: NSManagedObjectID) async -> Result<Country?, Error> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        do {
            let country = try self.manager.context.fetch(request).first(where: { $0.objectID == id })
            return .success(country)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findCity(id: Int) async -> Result<City?, Error> {
        let request = NSFetchRequest<City>(entityName: "City")
        do {
            let city = try self.manager.context.fetch(request).first(where: { $0.id == Int16(id) })
            return .success(city)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findPlace(id: Int) async -> Result<Place?, Error> {
        let request = NSFetchRequest<Place>(entityName: "Place")
        do {
            let place = try self.manager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(place)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findEvent(id: Int) async -> Result<Event?, Error> {
        let request = NSFetchRequest<Event>(entityName: "Event")
        do {
            let event = try self.manager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(event)
        } catch let error {
            return .failure(error)
        }
    }
    
    func getCity(id: NSManagedObjectID) async -> Result<City?, Error> {
        let request = NSFetchRequest<City>(entityName: "City")
        
        do {
            let city = try self.manager.context.fetch(request).first(where: { $0.objectID == id })
            return .success(city)
        } catch let error {
            return.failure(error)
        }
    }
    
    func findTag(tag: String) async -> Result<Tag?, Error> {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        
        do {
            let findedTag = try self.manager.context.fetch(request).first(where: { $0.name == tag })
            return .success(findedTag)
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
    
    func createRegion(decodedRegion: DecodedRegion) async -> Region {
        let newRegion = Region(context: manager.context)
        newRegion.id = Int16(decodedRegion.id)
        newRegion.name = decodedRegion.name
        newRegion.isActive = decodedRegion.isActive == 1 ? true : false
//        if let decodedCities = decodedRegion.cities {
//            for decodedCity in decodedCities {
//                let newCity = await createCity(decodedCity: decodedCity)
//                newRegion.addToCities(newCity)
//            }
//        }
        return newRegion
    }
    
    func createCity(decodedCity: DecodedCity) async -> City {
        let newCity = City(context: manager.context)
        newCity.id = Int16(decodedCity.id)
        newCity.name = decodedCity.name
        newCity.photo = decodedCity.photo
        newCity.isActive = decodedCity.isActive == 1 ? true : false
        return newCity
    }
    
    func createPlace(decodedPlace: DecodedPlace) async -> Place {
        let newPlace = Place(context: manager.context)
        newPlace.id = Int64(decodedPlace.id)
        newPlace.name = decodedPlace.name
     //   newPlace.about = decodedPlace.about
        newPlace.photo = decodedPlace.photo
//        if let phone = decodedPlace.phone {
//            newPlace.phone = Int64(phone)
//        }
        newPlace.latitude = decodedPlace.latitude
        newPlace.longitude = decodedPlace.longitude
        newPlace.isActive = decodedPlace.isActive == 1 ? true : false
        newPlace.address = decodedPlace.address
        newPlace.isChecked = decodedPlace.isChecked == 1 ? true : false
        
//        if let decodedTags = decodedPlace.tags {
//            for decodedTag in decodedTags {
//                let tag = await createTag(tag: decodedTag)
//                newPlace.addToTags(tag)
//            }
//        }
        return newPlace
    }
    
    func createEvent(decodedEvent: DecodedEvent) async -> Event {
        let newEvent = Event(context: manager.context)
        newEvent.id = Int64(decodedEvent.id)
        newEvent.name = decodedEvent.name
        newEvent.cover = decodedEvent.cover
        newEvent.address = decodedEvent.address
        newEvent.latitude = decodedEvent.latitude
        newEvent.longitude = decodedEvent.longitude
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
       // dateFormatter.timeZone = .gmt
        newEvent.startTime = dateFormatter.date(from: decodedEvent.startTime)
        newEvent.finishTime = dateFormatter.date(from: decodedEvent.finishTime)
        
        newEvent.isActive = decodedEvent.isActive == 1 ? true : false
        newEvent.isChecked = decodedEvent.isChecked == 1 ? true : false
        return newEvent
    }
    
    func createTag(tag: String) async -> Tag {
        let newTag = Tag(context: manager.context)
        newTag.name = tag
        return newTag
    }
}
