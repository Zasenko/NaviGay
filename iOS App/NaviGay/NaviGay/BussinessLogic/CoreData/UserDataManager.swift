//
//  UserDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import CoreData

protocol UserDataManagerProtocol {
 //   var user: User? { get }
    func findUser(id: Int) async -> User?
 //   func getUser() async -> User?
    func updateUser(user: User, decodedUser: DecodedUser) async -> Bool
    func saveNewUser(decodedUser: DecodedUser) async throws -> User
    func deleteUser(user: User) async -> Bool
}

final class UserDataManager {
    
    // MARK: - Properties
    
 //   var user: User? = nil
    
    // MARK: - Private Properties

    private let dataManager: CoreDataManagerProtocol
    private let networkManager: UserDataNetworkManagerProtocol
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol, networkManager: UserDataNetworkManagerProtocol) {
        self.dataManager = manager
        self.networkManager = networkManager
    }
}

// MARK: - UserDataManagerProtocol
extension UserDataManager: UserDataManagerProtocol {
    
    func updateUser(user: User, decodedUser: DecodedUser) async -> Bool {
        user.updateUser(decodedUser: decodedUser)
        do {
            try await dataManager.save()
        } catch {
            print("---ERROR UserDataManager updateUser(decodedUser: DecodedUser): ", error)
            return false
        }
        return true
    }
    
    func findUser(id: Int) async -> User? {
        let request = User.fetchRequest()
        
        do {
            let user = try dataManager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return user
        } catch {
            print("--ERROR UserDataManager findUser(id: Int)", error)
        }
        return nil
    }
    
//    func getUser() async -> User? {
//        let request = User.fetchRequest()
//        do {
//            let users = try self.dataManager.context.fetch(request)
//            if users.isEmpty {
//                return nil
//            } else if users.count > 1 {
//                print("---!!!!!!!!!!!!!!!!  users.count > 1")
//                user = users.first
//                return user
//            } else {
//                user = users.first
//                return user
//            }
//        } catch let error {
//            debugPrint(error)
//            return nil
//        }
//    }
    
    func saveNewUser(decodedUser: DecodedUser) async throws -> User {
        let newUser = User(context: dataManager.context)
        newUser.id = Int64(decodedUser.id)
        newUser.name = decodedUser.name
        newUser.photo = decodedUser.photo
        newUser.bio = decodedUser.bio
        newUser.status = decodedUser.status.rawValue
        if let email = decodedUser.email {
            newUser.email = email
        }
      //  user = newUser
        do {
            try await dataManager.save()
        } catch {
            print("--- ERROR UserDataManager saveNewUser(): \(error) , error:", error.localizedDescription)
        }
        
        return newUser
    }
    
    func deleteUser(user: User) async -> Bool {
        do {
            dataManager.context.delete(user)
            try await deleteLikesAfterLogOut()
            try await dataManager.save()
            return true
        } catch {
            print("--ERROR UserDataManager deleteUser: ", error)
        }
        return false
    }
}

extension UserDataManager {
    
    // MARK: - Private Functions
    
    private func deleteLikesAfterLogOut() async throws {
            let request = Place.fetchRequest()
            do {
                let likedPlaces = try dataManager.context.fetch(request).filter( { $0.isLiked == true } )
                likedPlaces.forEach { $0.isLiked = false }
            } catch {
                print("--ERROR UserDataManager deletePlaceLikesAfterLogOut", error)
            }
    }

    private func reloadLikedPlases(ids: [Int]?) {
        Task(priority: .background) {
            guard let ids = ids else { return }
            
            var noPlacesIds: [Int] = []
            
            for id in ids {
                switch await findPlace(id: id) {
                case .success(let place):
                    if let place = place {
                        place.isLiked = true
                        dataManager.saveData { _ in
                        }
                    } else {
                        noPlacesIds.append(id)
                    }
                case .failure(let error):
                    print("---UserDataManager ERROR switch PLACE - reloadLikedPlases(plasesId: [Int]): ", error)
                }
            }
            guard !noPlacesIds.isEmpty else {
                return
            }
            
            do {
                let result = try await networkManager.fetchPlaces(ids: noPlacesIds)
                
                if let error = result.error {
                    //TODO
                    print("--ERROR UserDataManager networkManager.fetchPlaces(ids: ids): ", error)
                    return
                }
                
                if let decodedPlaces = result.places, !decodedPlaces.isEmpty {
                    for decodedPlace in decodedPlaces {
                        let place: Place = await dataManager.createObject()
                        place.updateBasic(decodedPlace: decodedPlace)
                        for decodedTag in decodedPlace.tags {
                            switch await findTag(tag: decodedTag) {
                            case .success(let tag):
                                if let tag = tag {
                                    place.addToTags(tag)
                                } else {
                                    let tag = await createTag(tag: decodedTag)
                                    place.addToTags(tag)
                                }
                            case .failure(let error):
                                print("UserDataManager ERROR switch TAG - reloadLikedPlases(plasesId: [Int]): ", error)
                            }
                        }
                    }
                }
            } catch  {
                print("--ERROR UserDataManager reloadLikedPlases(ids: [Int]) ->>>>>>>>>>> \(error)")
            }
        }
    }
    
    private func findPlace(id: Int) async -> Result<Place?, Error> {
        let request = NSFetchRequest<Place>(entityName: "Place")
        do {
            let place = try self.dataManager.context.fetch(request).first(where: { $0.id == Int64(id) })
            return .success(place)
        } catch let error {
            return .failure(error)
        }
    }
    
    private func findTag(tag: String) async -> Result<Tag?, Error> {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        
        do {
            let findedTag = try self.dataManager.context.fetch(request).first(where: { $0.name == tag })
            return .success(findedTag)
        } catch let error {
            return.failure(error)
        }
    }
    
    private func createTag(tag: String) async -> Tag {
        let newTag = Tag(context: dataManager.context)
        newTag.name = tag
        return newTag
    }
}
