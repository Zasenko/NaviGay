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
        VStack {
            ZStack {
                UIKitMapView(mapViewModel: viewModel)
                    .ignoresSafeArea(.container, edges: .all)
                infoView
            }
            if viewModel.showInfoSheet {
                if let place = viewModel.selectedPlace {
                    MapPlaceView(viewModel: MapPlaceViewModel(place: place))
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge: .bottom),
                                            removal: .opacity))
                }
            }
        }
    }
    
    // MARK: - Views
    
    private var infoView: some View {
        VStack {
            HStack {
                MapSortingMenuView(categories: $viewModel.sortingCategories, selectedCategory: $viewModel.selectedSortingCategory) { category in
                    viewModel.sortingButtonTapped(category: category)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
