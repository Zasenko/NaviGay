//
//  DecodedPlace.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 10.07.23.
//

import Foundation

enum PlaceType: String, Codable {
    case bar, cafe, restaurant, club, hotel, sauna, cruise, beach, shop, gym, culture, community, other
}

struct PlacesResult: Codable {
    let error: String?
    let places: [DecodedPlace]?
}

struct PlaceResult: Codable {
    let error: String?
    let place: DecodedPlace?
}

struct DecodedPlace: Identifiable, Codable {
    let id: Int
    let name: String
    let type: PlaceType
    let latitude: Float
    let longitude: Float
    let address: String
    let isActive: Int
    let isChecked: Int
    let tags: [String]
    
    let about: String?
    let photo: String?
        
    let countryId: Int?
    let regionId: Int?
    let cityId: Int?
    
    let www: String?
    let fb: String?
    let insta: String?
    let phone: Int?
    
    let workingTimes: [DecodedWorkingHours]?
    let photos: [String]?
    let comments: [DecodedComment]?
}

//enum WeekDay: String, Codable {
//    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
//}

struct DecodedWorkingHours: Codable {
    let day: String
    let opening: String
    let closing: String
    
    private enum CodingKeys: String, CodingKey {
        case day = "day_of_week"
        case opening = "opening_time"
        case closing = "closing_time"
    }
}
