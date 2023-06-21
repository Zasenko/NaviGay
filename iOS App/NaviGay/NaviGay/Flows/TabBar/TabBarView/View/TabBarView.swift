//
//  TabBarView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct TabBarView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: TabBarViewModel
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader {
            
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            
            VStack {
                switch viewModel.selectedPage {
                case .aroundMe:
                    aroundMeView
                case .search:
                    CatalogView(viewModel: CatalogViewModel(networkManager: viewModel.catalogNetworkManager,
                                                            dataManager: viewModel.catalogDataManager,
                                                            safeArea: safeArea,
                                                            size: size))
                case .user:
                    Color.orange
                }
                tabBar
            }
            .alert(isPresented: $viewModel.showLocationAlert) {
                //TODO!!!! текст
                Alert(title: Text("Camera access required to take photos"),
                      message: Text("Go to Settings?"),
                      primaryButton: .default(Text("Settings"),
                                              action: { viewModel.settingsButtonTapped() }),
                      secondaryButton: .default(Text("Cancel"),
                                                action: { viewModel.cancleButtonTapped() }))
            }
        }
    }
    
    private var tabBar: some View {
        HStack {
            if !viewModel.isLocationDenied {
                TabBarAroundMeButtonView(tabBarButton: viewModel.aroundMeButton, selectedPage: $viewModel.selectedPage, aroundMeSelectedPage: $viewModel.aroundMeSelectedPage)
            }
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.catalogButton)
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.userButton)
        }
        .padding(.top, 12)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder private var aroundMeView: some View {
        switch viewModel.aroundMeSelectedPage {
        case .home:
            Color.brown
        case .map:
            MapView(viewModel: MapViewModel(locationManager: viewModel.locationManager,
                                            dataManager: viewModel.mapDataManager))
        }
    }
}
