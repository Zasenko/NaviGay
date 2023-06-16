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
            if let place = viewModel.selectedAnnotation {
                VStack {
                    Spacer()
                    Color.red
                        .frame(height: 100)
                }
            }
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
