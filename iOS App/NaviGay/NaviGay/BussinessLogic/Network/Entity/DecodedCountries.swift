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
   // let lastUpdate: String
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

struct DecodedCity: Identifiable, Codable {
    let id: Int
    let name: String
    let isActive: Int
}
