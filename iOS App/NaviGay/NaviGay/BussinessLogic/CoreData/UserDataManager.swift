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
    func deleteUser() async
}

final class UserDataManager {
    
    // MARK: - Private Properties

    private let dataManager: CoreDataManagerProtocol
    private let networkManager: UserDataNetworkManagerProtocol
    private var user: User? = nil
    
    // MARK: - Inits
    
    init(manager: CoreDataManagerProtocol, networkManager: UserDataNetworkManagerProtocol) {
        self.dataManager = manager
        self.networkManager = networkManager
    }
}

// MARK: - UserDataManagerProtocol
extension UserDataManager: UserDataManagerProtocol {
    
    func checkIsUserLogin() async -> Result<Bool, Error> {
        let request = User.fetchRequest()
        do {
            let users = try self.dataManager.context.fetch(request)
            if users.isEmpty {
                return .success(false)
            } else {
                user = users.first
                return .success(true)
            }
        } catch let error {
            return.failure(error)
        }
    }
    
    func saveNewUser(decodedUser: DecodedUser) async {
        let newUser = User(context: dataManager.context)
        newUser.id = Int64(decodedUser.id)
        newUser.name = decodedUser.name
        newUser.photo = decodedUser.photo
        newUser.bio = decodedUser.bio
        newUser.status = decodedUser.status.rawValue
        user = newUser
        dataManager.saveData { _ in
            
        }
        reloadLikedPlases(ids: decodedUser.likedPlacesId)
    }
    
    func deleteUser() async {
        let request = User.fetchRequest()
        do {
            let users = try self.dataManager.context.fetch(request)
            users.forEach { self.dataManager.context.delete($0) }
            dataManager.saveData { _ in
                
            }
        } catch let error {
            print("UserDataManager ERROR deleteUser(): ", error)
        }
    }
}

extension UserDataManager {
    
    // MARK: - Private Functions
    
    private func reloadLikedPlases(ids: [Int]) {
        Task(priority: .background) {
            var emptyPlaces: [Int] = []
            
            for id in ids {
                switch await findPlace(id: id) {
                case .success(let place):
                    if let place = place {
                        place.isLiked = true
                        dataManager.saveData { _ in
                        }
                    } else {
                        emptyPlaces.append(id)
                    }
                case .failure(let error):
                    print("UserDataManager ERROR switch PLACE - reloadLikedPlases(plasesId: [Int]): ", error)
                }
            }
            guard !emptyPlaces.isEmpty else {
                return
            }
            
            do {
                let result = try await networkManager.fetchPlaces(ids: ids)
                
                if let error = result.error {
                    //TODO
                    print("UserDataManager ERROR networkManager.fetchPlaces(ids: ids): ", error)
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
                print("UserDataManager ERROR reloadLikedPlases(ids: [Int]) ->>>>>>>>>>> \(error)")
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
