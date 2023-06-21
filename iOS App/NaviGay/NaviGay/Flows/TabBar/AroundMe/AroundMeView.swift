//
//  AroundMeView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import SwiftUI

struct AroundMeView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: AroundMeViewModel
    @Binding var selectedPage: AroundMeRouter
    
    // MARK: - Body
    
    var body: some View {
        switch selectedPage {
        case .home:
            Color.brown
        case .map:
            MapView(viewModel: MapViewModel(locationManager: viewModel.locationManager,
                                            dataManager: viewModel.dataManager))
        }
    }
}

//struct AroundMeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AroundMeView()
//    }
//}
