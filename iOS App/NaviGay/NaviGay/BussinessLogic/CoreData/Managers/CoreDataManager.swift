//
//  CoreDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import CoreData

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get }
    
    // TODO!!! убрать этот метод
    func saveData(complition: @escaping( (Bool) -> Void ))
    
    func save() async throws
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> T?
    func createObject<T: NSManagedObject>() async -> T
}

enum CoreDataManagerError: Error {
    case contextDontHasChanges
    case didntSaveData
    case cantCreateUser
    case userDidntHasEmail
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    //MARK: - Properties
    
    var context: NSManagedObjectContext
    
    //MARK: - Private Properties
    
    private let container: NSPersistentContainer
    
    //MARK: - Inits
    
    init() {
        container = NSPersistentContainer (name: "NaviGay")
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                //TODO
                debugPrint ("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
}

extension CoreDataManager {
    
    //MARK: - Functions

    // TODO!!! убрать этот метод
    func saveData(complition: @escaping( (Bool) -> Void )) {
        DispatchQueue.main.async {

            if self.context.hasChanges {
                do {
                    try self.context.save()
                    complition(true)
                } catch let error {
                    debugPrint("CoreDataManager saveData() Error: ", error.localizedDescription)
                    complition(false)
                }
            }

        }
    }
    
    func save() async throws {
        guard context.hasChanges else {
            throw CoreDataManagerError.contextDontHasChanges
        }
        do {
            try self.context.save()
        } catch {
            throw error
        }
    }
    
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> T? {
        let request = NSFetchRequest<T>(entityName: entityName)
        do {
            let object = try context.fetch(request).first(where: { $0.objectID == id })
            return object
        } catch let error {
            debugPrint("CoreDataManager getObject() Error: ", error.localizedDescription)
            return nil
        }
    }

    func createObject<T: NSManagedObject>() async -> T {
        let newObject = T(context: context)
        return newObject
    }
}


