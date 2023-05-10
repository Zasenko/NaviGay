//
//  RegionsView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

struct RegionsView: View {
    
    //@StateObject var viewModel: RegionsViewModel
    
    @Binding var regions: [Region]
    
    var body: some View {
        LazyVStack {
//            ForEach($regions) { region in
//
//                Section {
//                    CityView(cities: region.cities)
//                } header: {
//                    Text(region.name ?? "")
//                } footer: {}
//
//            }
        }
    }
    
}

//struct CitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CitiesView()
//    }
//}

struct CityView: View {
    
    //@StateObject var viewModel: RegionsViewModel
    
    @Binding var cities: [City]
    
    var body: some View {
        VStack {
            ForEach(cities) { city in
                Text(city.name ?? "")
            }
        }
        
    }
    
}
