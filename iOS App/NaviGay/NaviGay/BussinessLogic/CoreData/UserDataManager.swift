//
//  UserDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import CoreData

protocol UserDataManagerProtocol {
    func checkIsUserLogin() async -> Result<Bool, Error>
    func saveNewUser(decodedUser: DecodedUser) async
}

final class UserDataManager {
    
    // MARK: - Private Properties

    private let manager: CoreDataManagerProtocol
    private var user: User? = nil
    
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
                user = users.first
                return .success(true)
            } else {
                return .success(false)
            }
        } catch let error {
            return.failure(error)
        }
    }
    
    func saveNewUser(decodedUser: DecodedUser) async {
        let newUser = User(context: manager.context)
        newUser.id = Int32(decodedUser.id)
        newUser.name = decodedUser.name
        newUser.photo = decodedUser.photo
        newUser.bio = decodedUser.bio
        newUser.status = decodedUser.status.rawValue
        user = newUser
        manager.saveData()
    }
}
