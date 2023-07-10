//
//  DecodedCity.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 10.07.23.
//

import Foundation

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
