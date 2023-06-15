//
//  MapView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: MapViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            UIKitMapView(mapViewModel: viewModel)
            
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
