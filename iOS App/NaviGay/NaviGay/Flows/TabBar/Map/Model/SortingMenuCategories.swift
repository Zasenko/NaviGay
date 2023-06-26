//
//  SortingMenuCategories.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import Foundation

enum SortingMenuCategories: String {
    case bar, cafe, restaurant, club, hotel, sauna, cruise, beach, shop, gym, culture, community
    case events
    case all
    
    func getName() -> String {
        switch self {
        case .bar:
            return "bars"
        case .cafe:
            return "cafes"
        case .restaurant:
            return "restaurants"
        case .club:
            return "clubs"
        case .hotel:
            return "hotels"
        case .sauna:
            return "saunas"
        case .cruise:
            return "cruises"
        case .beach:
            return "beaches"
        case .shop:
            return "shops"
        case .gym:
            return "gyms"
        case .culture:
            return "culture"
        case .community:
            return "communities"
        case .events:
            return "events"
        case .all:
            return "all locations"
        }
    }
}
