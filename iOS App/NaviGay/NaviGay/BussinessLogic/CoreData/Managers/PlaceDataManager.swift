//
//  PlaceDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import CoreData

protocol PlaceDataManagerProtocol {
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> Result<T?, Error>
    func createObject<T: NSManagedObject>() async -> T
    func findPlace(id: Int) async -> Result<Place?, Error>
    func findTag(tag: String) async -> Result<Tag?, Error>
    func findWorkingTime(workingHours: DecodedWorkingHours) async -> Result<WorkingTime?, Error>
    func findPhoto(id: String) async -> Result<Photo?, Error>
    func findComment(id: Int) async -> Result<PlaceComment?, Error>
    func save(complition: @escaping( (Bool) -> Void ))
}


final class PlaceDataManager {
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}

//MARK: - PlaceDataManagerProtocol
extension PlaceDataManager: PlaceDataManagerProtocol {
    
    func findPlace(id: Int) async -> Result<Place?, Error> {
        let request = Place.fetchRequest()
        do {
            let place = try self.manager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(place)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findComment(id: Int) async -> Result<PlaceComment?, Error> {
        let request = PlaceComment.fetchRequest()
        do {
            let comment = try self.manager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(comment)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findPhoto(id: String) async -> Result<Photo?, Error> {
        let request = Photo.fetchRequest()
        do {
            let photo = try self.manager.context.fetch(request).first(where: { $0.url == id })
            return .success(photo)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findWorkingTime(workingHours: DecodedWorkingHours) async -> Result<WorkingTime?, Error> {
        let request = WorkingTime.fetchRequest()
        do {
            let workingTimes = try self.manager.context.fetch(request)
                
            let a = workingTimes.first(where: { $0.day == workingHours.day && $0.open == workingHours.opening && $0.close == workingHours.closing })
            
            
            
            return .success(a)
        } catch let error {
            return .failure(error)
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
    
    func save(complition: @escaping( (Bool) -> Void )) {
        manager.saveData { result in
            if result {
                complition(true)
            } else {
                complition(false)
            }
        }
    }
    
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> Result<T?, Error> {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            let object = try self.manager.context.fetch(request).first(where: { $0.objectID == id })
            return .success(object)
        } catch let error {
            return .failure(error)
        }
    }

    func createObject<T: NSManagedObject>() async -> T {
        let newObject = T(context: manager.context)
        return newObject
    }
}
