//
//  PlaceViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import SwiftUI

final class PlaceViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var place: Place
    @Published var placeImage: Image = AppImages.appIcon
    
    let networkManager: PlaceNetworkManagerProtocol
    let dataManager: PlaceDataManagerProtocol
    
    //MARK: - Inits
    
    init(place: Place,
         networkManager: PlaceNetworkManagerProtocol,
         dataManager: PlaceDataManagerProtocol) {
        self.place = place
        self.networkManager = networkManager
        self.dataManager = dataManager
        loadImage()
        getPlace()
    }
}

extension PlaceViewModel {
    
    //MARK: - Private Functions
    
    private func getPlace() {
        Task {
            await fetchPlace()
        }
    }
    
    private func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = place.photo else { return }
        do {
            self.placeImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            //TODO
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func reloadPlace() async {
        let result = await dataManager.getObject(id: place.objectID, entityName: "Place")
        switch result {
        case .success(let place):
            if let place = place as? Place {
                withAnimation(.spring()) {
                    self.place = place
                }
            } else {
            }
        case .failure(let error):
            // TODO
            print("CountryViewModel getCountryFromDB() failure ->>>>>>>>>>> ", error)
        }
    }
    
    
    @MainActor
    private func fetchPlace() {
        Task {
            do {
                let result = try await networkManager.fetchPlace(id: Int(place.id))
                if let error = result.error {
                    //TODO
                    print(error)
                    return
                }
                
                guard let decodedPlace = result.place else { return }
                place.about = decodedPlace.about
                place.address = decodedPlace.address
                place.fb = decodedPlace.fb
                place.insta = decodedPlace.insta
               // place.phone = decodedPlace.phone?.formatted()
                place.photo = decodedPlace.photo
                place.latitude = decodedPlace.latitude
                place.longitude = decodedPlace.longitude
                place.www = decodedPlace.www
                
                place.isActive = decodedPlace.isActive == 1 ? true : false
                place.isChecked = decodedPlace.isChecked == 1 ? true : false

                
                if let tags = place.tags?.allObjects as? [Tag] {
                    for tag in tags {
                        place.removeFromTags(tag)
                    }
                }
                
                for decodedTag in decodedPlace.tags {
                    switch await dataManager.findTag(tag: decodedTag) {
                    case .success(let tag):
                        if let tag = tag {
                            place.addToTags(tag)
                        } else {
                            let tag: Tag = await dataManager.createObject()
                            tag.name =  decodedTag
                            place.addToTags(tag)
                        }
                    case .failure(let error):
                        //TODO
                        print("fetchCountry() - findCity failure :", error)
                    }
                }
                
                if let workingTimes = place.workingTimes?.allObjects as? [WorkingTime] {
                    for workingTime in workingTimes {
                        place.removeFromWorkingTimes(workingTime)
                    }
                }
                guard let decodedWorkingTimes = decodedPlace.workingTimes else {return}
                for decodedWorkingTime in decodedWorkingTimes {
                    switch await dataManager.findWorkingTime(workingHours: decodedWorkingTime) {
                    case .success(let workingHours):
                        if let workingHours = workingHours {
                            place.addToWorkingTimes(workingHours)
                        } else {
                            let workingHours: WorkingTime = await dataManager.createObject()
                            workingHours.day = decodedWorkingTime.day.rawValue
                            workingHours.open = decodedWorkingTime.opening
                            workingHours.close = decodedWorkingTime.closing
                            place.addToWorkingTimes(workingHours)
                        }
                    case .failure(let error):
                        //TODO
                        print("fetchCountry() - findCity failure :", error)
                    }
                }
                
                if let photos = place.photos?.allObjects as? [Photo] {
                    for photo in photos {
                        place.removeFromPhotos(photo)
                    }
                }
                guard let decodedPhotos = decodedPlace.photos else {return}
                for decodedPhoto in decodedPhotos {
                    switch await dataManager.findPhoto(id: decodedPhoto) {
                    case .success(let photo):
                        
                        if let photo = photo {
                            place.addToPhotos(photo)
                        } else {
                            let photo: Photo = await dataManager.createObject()
                            photo.url  = decodedPhoto
                            place.addToPhotos(photo)
                        }
                    case .failure(let error):
                        //TODO
                        print("fetchCountry() - findCity failure :", error)
                    }
                }
                
                if let comments = place.comments?.allObjects as? [PlaceComment] {
                    for comment in comments {
                        place.removeFromComments(comment)
                    }
                }
                guard let decodedComments = decodedPlace.comments else {return}
                for decodedComment in decodedComments {
                    switch await dataManager.findComment(id: decodedComment.id) {
                    case .success(let comment):
                        
                        if let comment = comment {
                            place.addToComments(comment)
                        } else {
                            let comment: PlaceComment = await dataManager.createObject()
                            comment.id  = Int64(decodedComment.id)
                            comment.text  = decodedComment.comment
                            comment.createdAt = decodedComment.createdAt
                            comment.userName = decodedComment.userName
                            comment.userPhoto  = decodedComment.userPhoto
                            comment.userId  = Int64(decodedComment.userId)
                            place.addToComments(comment)
                        }
                    case .failure(let error):
                        //TODO
                        print("fetchCountry() - findCity failure :", error)
                    }
                }
                

                    dataManager.save() { [weak self] result in
                        if result {
                            Task {
                                await self?.reloadPlace()
                            }
                        }
                    }
//
            } catch {

                //TODO

                print("Error fetching country ->>>>>>>>>>> \(error)")
            }
        }
    }
}
