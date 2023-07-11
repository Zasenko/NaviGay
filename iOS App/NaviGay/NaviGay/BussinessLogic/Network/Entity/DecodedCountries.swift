//
//  DecodedCountries.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import Foundation

struct DecodedComment: Identifiable, Codable {
    let id: Int
    let userId: Int
    let userName: String
    let userPhoto: String?
    let comment: String
    let createdAt: String
}

struct LocationsAroundResult: Codable {
    let error: String?
    let events: [DecodedEvent]?
    let places: [DecodedPlace]?
}
