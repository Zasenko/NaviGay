//
//  CoreDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import CoreData

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get }
    
    func saveData(complition: @escaping( (Bool) -> Void ))
    func getObject<T: NSManagedObject>(id: NSManagedObjectID, entityName: String) async -> T?
    func createObject<T: NSManagedObject>() async -> T
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

    func saveData(complition: @escaping( (Bool) -> Void )) {
        DispatchQueue.main.async {
            do {
                try self.context.save()
                    complition(true)
            } catch let error {
                debugPrint("CoreDataManager saveData() Error: ", error.localizedDescription)
                complition(false)
            }
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


