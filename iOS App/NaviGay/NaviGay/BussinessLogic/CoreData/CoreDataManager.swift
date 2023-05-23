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
          //      debugPrint("CoreDataManager  Saving ->>>>>>>>>> OK")
                    complition(true)
            } catch let error {
                //TODO
                debugPrint("CoreDataManager Error ->>>>>>>>>> \(error)")
                complition(false)
            }
        }
    }
}


