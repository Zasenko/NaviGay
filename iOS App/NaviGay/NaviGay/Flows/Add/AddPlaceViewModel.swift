//
//  AddPlaceViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 20.06.23.
//

import SwiftUI

final class AddPlaceViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var type: PlaceType = .bar
    @Published var about: String = ""
    @Published var photo: String = ""
    @Published var country_id: String = ""
    @Published var region_id: String = ""
    
    //?
    @Published var city_id: String = ""
    
    @Published var address: String = ""
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
    //?
    @Published var www: String = ""
    @Published var fb: String = ""
    @Published var insta: String = ""
    @Published var phone: String = ""
    
    @Published var tags: String = ""
    @Published var photos: String = ""
    @Published var WorkingTime: String = ""
}
