//
//  UserDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import CoreData

protocol UserDataManagerProtocol {
    func findUser(id: Int) async throws -> User?
    func createEmptyUser(decodedUser: DecodedUser) async -> User
    func updateUser(user: User, decodedUser: DecodedUser) async throws
    func deleteUser(user: User) async throws
    func save() async throws
}

final class UserDataManager {

    // MARK: - Private Properties

    private let dataManager: CoreDataManagerProtocol
    private let networkManager: UserDataNetworkManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol,
         networkManager: UserDataNetworkManagerProtocol) {
        self.dataManager = manager
        self.networkManager = networkManager
    }
}

// MARK: - UserDataManagerProtocol
extension UserDataManager: UserDataManagerProtocol {
    
    //ok
    func findUser(id: Int) async throws -> User? {
        let request = User.fetchRequest()
        do {
            return try dataManager.context.fetch(request).first(where: { $0.id == Int64(id) })
        } catch {
            throw error
        }
    }
    
    //ok
    func save() async throws {
        do {
            try await dataManager.save()
        } catch {
            throw error
        }
    }
    
    //ok
//    func createEmptyUser() async -> User {
//        let newUser: User = await dataManager.createObject()
//        return newUser
//    }
    
    func createEmptyUser(decodedUser: DecodedUser) async -> User {
        let newUser: User = await dataManager.createObject()
        newUser.id = Int64(decodedUser.id)
        newUser.updateUser(decodedUser: decodedUser)
        return newUser
    }
    
    //ok
    func deleteUser(user: User) async throws {
        do {
            dataManager.context.delete(user)
            try await deletePlacesLikes()
            try await dataManager.save()
        } catch {
            throw error
        }
    }
    

    func updateUser(user: User, decodedUser: DecodedUser) async throws {
        user.updateUser(decodedUser: decodedUser)
        do {
            try await reloadLikedPlases(ids: decodedUser.likedPlacesId)
        } catch {
            throw error
        }
    }
    
    //подумать - слишком большая и запутанная / разделить на части? / ошибка может быть если нет интернета
     func reloadLikedPlases(ids: [Int]?) async throws {
         do {
             try await deletePlacesLikes()
             guard let ids = ids else { return }
             var notFoundedPlacesIDs: [Int] = []
             
             //реквест был до этого в функции deletePlacesLikes дло этого
             let request = Place.fetchRequest()
             let places = try dataManager.context.fetch(request)
             
             for id in ids {
                 if let place = places.first(where: { $0.id == Int64(id) } ) {
                     place.isLiked = true
                 } else {
                     notFoundedPlacesIDs.append(id)
                 }
             }
             guard !notFoundedPlacesIDs.isEmpty else {
                 return
             }
             let result = try await networkManager.fetchPlaces(ids: notFoundedPlacesIDs)
             if result.error != nil {
                 if let errorDescription = result.error {
                     throw NetworkErrors.apiErrorWithMassage(errorDescription)
                 } else {
                     throw NetworkErrors.apiError
                 }
             }
             if let decodedPlaces = result.places, !decodedPlaces.isEmpty {
                 for decodedPlace in decodedPlaces {
                     let place: Place = await dataManager.createObject()
                     place.id = Int64(decodedPlace.id)
                     place.updateBasic(decodedPlace: decodedPlace)
                     for decodedTag in decodedPlace.tags {
                         if let tag = try await findTag(tag: decodedTag) {
                             place.addToTags(tag)
                         } else {
                             let tag = await createTag(tag: decodedTag)
                             place.addToTags(tag)
                         }
                     }
                 }
             }
         } catch {
             throw error
         }
    }
}

extension UserDataManager {
    
    // MARK: - Private Functions
    
    //ok
    private func deletePlacesLikes() async throws {
        let request = Place.fetchRequest()
        do {
            let likedPlaces = try dataManager.context.fetch(request).filter( { $0.isLiked == true } )
            likedPlaces.forEach { $0.isLiked = false }
        } catch {
            throw error
        }
    }
    
    //TODO!!! функция повторяется несколько раз!
    //ok
    private func findPlace(id: Int) async throws -> Place? {
        let request = Place.fetchRequest()
        do {
            return try self.dataManager.context.fetch(request).first(where: { $0.id == Int64(id) })
        } catch {
            throw error
        }
    }

    //TODO!!! функция повторяется несколько раз!
    //ok
    private func findTag(tag: String) async throws -> Tag? {
        let request = Tag.fetchRequest()
        
        do {
            let tag = try self.dataManager.context.fetch(request).first(where: { $0.name == tag })
            return tag
        } catch let error {
            throw error
        }
    }
    
    //TODO!!! функция повторяется несколько раз!
    //ok
    private func createTag(tag: String) async -> Tag {
        let newTag: Tag = await dataManager.createObject()
        newTag.name = tag
        return newTag
    }
}
