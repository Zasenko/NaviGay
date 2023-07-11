//
//  DecodedRegion.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 10.07.23.
//

import Foundation

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
