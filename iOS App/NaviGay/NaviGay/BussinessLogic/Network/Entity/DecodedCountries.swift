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
}

enum PlaseType: String, Codable {
    case bar, cafe, restaurant, club, hotel, sauna, cruise, beach, shop, gym, culture, community
}

struct DecodedPlace: Identifiable, Codable {
    let id: Int
    let name: String
    let type: PlaseType
    let latitude: Float
    let longitude: Float
    let address: String
    let isActive: Int
    let isChecked: Int
    
    let about: String?
    let photo: String?
    let phone: Int?
    let tags: [String]?
    let workingTimes: [WorkingHours]?
}

//enum Tags: String, Codable {
//    case pool, darkroom, terrace
//    case dragShow = "drag show"
//    case straightFriendly = "straight friendly"
//    case gayFriendly = "gay friendly"
//    case menOnly = "men only"
//}

enum WeekDay: String, Codable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

struct WorkingHours: Codable {
    let day: WeekDay
    let opening: String
    let closing: String
    
    private enum CodingKeys: String, CodingKey {
        case day = "day_of_week"
        case opening = "opening_time"
        case closing = "closing_time"
    }
}
