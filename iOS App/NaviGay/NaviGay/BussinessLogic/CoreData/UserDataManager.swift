//
//  UserDataManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import CoreData

protocol UserDataManagerProtocol {
    var user: User? { get }
    func checkIsUserLogin() async -> Result<Bool, Error>
    func saveNewUser(decodedUser: DecodedUser) async
    func deleteUser(complition: @escaping( (Bool) -> Void ))
}

final class UserDataManager {
    
    // MARK: - Properties
    
    var user: User? = nil
    
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
    
    func deleteUser(complition: @escaping( (Bool) -> Void )) {
        let request = User.fetchRequest()
        do {
            let users = try self.dataManager.context.fetch(request)
            users.forEach { self.dataManager.context.delete($0) }
            dataManager.saveData { [weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.deleteLikesAfterLogOut { [weak self] result in
                            if result {
                                complition(true)
                            } else {
                                complition(false)
                            }
                        }
                        
                    } else {
                        complition(false)
                    }
                }
            }
        } catch let error {
            print("UserDataManager ERROR deleteUser(): ", error)
            DispatchQueue.main.async {
                complition(false)
            }
        }
    }
}

extension UserDataManager {
    
    // MARK: - Private Functions
    
    func deleteLikesAfterLogOut(complition: @escaping( (Bool) -> Void )) {
            let request = Place.fetchRequest()
            do {
                let likedPlaces = try self.dataManager.context.fetch(request).filter( { $0.isLiked == true } )
                likedPlaces.forEach { $0.isLiked = false }
                dataManager.saveData { [weak self] result in
                    if result {
                        complition(true)
                    } else {
                        complition(false)
                    }
                }
            } catch {
                complition(false)
            }
    }
    
    private func reloadLikedPlases(ids: [Int]) {
        Task(priority: .background) {
            var emptyPlacesIds: [Int] = []
            
            for id in ids {
                switch await findPlace(id: id) {
                case .success(let place):
                    if let place = place {
                        place.isLiked = true
                        dataManager.saveData { _ in
                        }
                    } else {
                        emptyPlacesIds.append(id)
                    }
                case .failure(let error):
                    print("UserDataManager ERROR switch PLACE - reloadLikedPlases(plasesId: [Int]): ", error)
                }
            }
            guard !emptyPlacesIds.isEmpty else {
                return
            }
            
            do {
                let result = try await networkManager.fetchPlaces(ids: emptyPlacesIds)
                
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
