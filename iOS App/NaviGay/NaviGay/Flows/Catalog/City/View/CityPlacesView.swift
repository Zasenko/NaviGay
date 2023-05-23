//
//  CityPlacesView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//

import SwiftUI
import Combine


struct CityPlacesView: View {
    
    //MARK: - Proreties
    
    @Binding var places: [(key: String, value: [Place])]
    let size: CGSize
    
    //MARK: - Body
    
    var body: some View {
        ForEach(places, id: \.key) { type, places in
            VStack {
                Text(type)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(places) { place in
                            CityPlaceView(viewModel: CityPlaceViewModel(place: place), size: size)
                        }
                    }
                }
                .frame(width: size.width)
            }
        }
    }
}

//struct CityPlacesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPlacesView()
//    }
//}
