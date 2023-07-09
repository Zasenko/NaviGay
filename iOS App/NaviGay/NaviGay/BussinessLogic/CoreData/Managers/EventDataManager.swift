//
//  EventDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 26.05.23.
//

import CoreData

protocol EventDataManagerProtocol {
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> Result<T?, Error>
    func createObject<T: NSManagedObject>() async -> T
    func findEvent(id: Int) async -> Result<Event?, Error>
    func findTag(tag: String) async -> Result<Tag?, Error>
    func findPhoto(id: String) async -> Result<Photo?, Error>
    func save(complition: @escaping( (Bool) -> Void ))
}


final class EventDataManager {
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}

//MARK: - PlaceDataManagerProtocol
extension EventDataManager: EventDataManagerProtocol {
    
    func findEvent(id: Int) async -> Result<Event?, Error> {
        let request = NSFetchRequest<Event>(entityName: "Event")
        do {
            let event = try self.manager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(event)
        } catch let error {
            return .failure(error)
        }
    }
    
    func findPhoto(id: String) async -> Result<Photo?, Error> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        do {
            let photo = try self.manager.context.fetch(request).first(where: { $0.url == id })
            return .success(photo)
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
