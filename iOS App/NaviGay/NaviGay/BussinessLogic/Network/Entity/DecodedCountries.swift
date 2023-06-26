//
//  DecodedCountries.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import Foundation

struct CountriesResult: Codable {
    let error: String?
    let countries: [DecodedCountry]?
}

struct CountryResult: Codable {
    let error: String?
    let country: DecodedCountry?
}

struct DecodedCountry: Identifiable, Codable {
    let id: Int
    let name: String
    let about: String
    let flag: String
    let photo: String
    let regions: [DecodedRegion]?
    let isActive: Int
}

struct RegionsResult: Codable {
    let error: String?
    let country: [DecodedRegion]?
}

struct DecodedRegion: Identifiable, Codable {
    let id: Int
    let name: String
    let cities: [DecodedCity]?
    let isActive: Int
}

struct CityResult: Codable {
    let error: String?
    let city: DecodedCity?
}

struct DecodedCity: Identifiable, Codable {
    let id: Int
    let name: String
    let about: String?
    let photo: String
    let isActive: Int
    let places: [DecodedPlace]?
    let events: [DecodedEvent]?
}

enum PlaceType: String, Codable {
    case bar, cafe, restaurant, club, hotel, sauna, cruise, beach, shop, gym, culture, community, defaultValue
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

struct DecodedComment: Identifiable, Codable {
    let id: Int
    let userId: Int
    let userName: String
    let userPhoto: String?
    let comment: String
    let createdAt: String
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


//enum EventType: String, Codable {
//    case party, pride
//}
struct EventResult: Codable {
    let error: String?
    let event: DecodedEvent?
}

struct DecodedEvent: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let cover: String? // почему ?  узнать api
    
    let address: String
    let latitude: Float
    let longitude: Float
    
    let startTime: String
    let finishTime: String
    
    let isActive: Int
    let isChecked: Int

    let tags: [String]
}

struct LocationsAroundResult: Codable {
    let error: String?
    let events: [DecodedEvent]?
    let places: [DecodedPlace]?
}
