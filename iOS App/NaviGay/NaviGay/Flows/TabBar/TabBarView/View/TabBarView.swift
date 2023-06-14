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
                VStack {
                    switch viewModel.selectedPage {
                    case .home:
                        Color.red
                    case .user:
                        Color.red
                    case .map:
                        MapView()
                            .ignoresSafeArea()
                    case .catalog:
                        CatalogView(viewModel: CatalogViewModel(networkManager: viewModel.catalogNetworkManager,
                                                                dataManager: viewModel.catalogDataManager,
                                                                safeArea: safeArea,
                                                                size: size))
                    }
                    Spacer()
                }
                .ignoresSafeArea(.container, edges: .all)
                tabBar
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
                TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.mapButton)
                TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.calendarButton)
            }
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.catalogButton)
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.userButton)
        }
    }
}
