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
    case other
    
    func getName() -> String {
        switch self {
        case .bar:
            return "Bars"
        case .cafe:
            return "Cafes"
        case .restaurant:
            return "Restaurants"
        case .club:
            return "Clubs"
        case .hotel:
            return "Hotels"
        case .sauna:
            return "Saunas"
        case .cruise:
            return "Cruises"
        case .beach:
            return "Beaches"
        case .shop:
            return "Shops"
        case .gym:
            return "Gyms"
        case .culture:
            return "Culture"
        case .community:
            return "Communities"
        case .events:
            return "Events"
        case .all:
            return "All locations"
        case .other:
            return "Other"
        }
    }
}
