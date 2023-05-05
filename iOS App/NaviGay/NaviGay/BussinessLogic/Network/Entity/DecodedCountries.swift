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

struct DecodedCountry: Identifiable, Codable {
    let id: Int
    let name: String
    let about: String
    let flag: String
    let photo: String
  //  let cities: [CityApi]
    let isActive: Int
   // let lastUpdate: String
}
