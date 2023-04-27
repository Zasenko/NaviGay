//
//  UserDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI
import CoreData

protocol UserDataManagerProtocol {
    func checkIsUserLogin() async -> Result<Bool, Error>
}

final class UserDataManager {
    
    // MARK: - Private Properties
    
    private let manager: CoreDataManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol) {
        self.manager = manager
    }
}
// MARK: - UserDataManagerProtocol

extension UserDataManager: UserDataManagerProtocol {
    
    func checkIsUserLogin() async -> Result<Bool, Error> {
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            let users = try self.manager.context.fetch(request)
            if !users.isEmpty {
                return .success(true)
            } else {
                return .success(false)
            }
        } catch let error {
            return.failure(error)
        }
    }
}
