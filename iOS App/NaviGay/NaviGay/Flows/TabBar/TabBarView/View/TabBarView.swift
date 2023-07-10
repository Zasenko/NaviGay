//
//  TabBarView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct TabBarView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: TabBarViewModel
    
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
                                                            placeNetworkManager: viewModel.placeNetworkManager,
                                                            placeDataManager: viewModel.placeDataManager,
                                                            safeArea: safeArea,
                                                            size: size))
                case .user:
                    UserView(viewModel: UserViewModel(userDataManager: viewModel.userDataManager,
                                                      keychinWrapper: viewModel.keychinWrapper,
                                                      entryRouter: $viewModel.entryRouter,
                                                      isUserLoggedIn: $viewModel.isUserLoggedIn,
                                                      user: $viewModel.user))
                }
                tabBar
            }
            .alert(isPresented: $viewModel.showLocationAlert) {
                //TODO!!!! текст
                Alert(title: Text("Locarion access"),
                      message: Text("Go to Settings?"),
                      primaryButton: .default(Text("Settings"),
                                              action: { viewModel.settingsButtonTapped() }),
                      secondaryButton: .default(Text("Cancel"),
                                                action: { viewModel.cancleButtonTapped() }))
            }
        }
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
    
    private var tabBar: some View {
        HStack {
            if !viewModel.isLocationDenied {
                TabBarAroundMeButtonView(tabBarButton: viewModel.aroundMeButton, selectedPage: $viewModel.selectedPage, aroundMeSelectedPage: $viewModel.aroundMeSelectedPage)
                
            }
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.catalogButton)
            userButton
        }
        .background(Color.green)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private var userButton: some View {
        Button {
            viewModel.selectedPage = .user
        } label: {
            if viewModel.isUserLoggedIn {
                CachedImageView(viewModel: CachedImageViewModel(url: viewModel.user?.photo)) {
                    AppImages.iconPerson
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(viewModel.selectedPage == .user ? AppColors.red : AppColors.lightGray5)
                }
                .frame(width: 30, height: 30)
                .mask(Circle())
                
            } else {
                AppImages.iconPerson
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(viewModel.selectedPage == .user ? AppColors.red : AppColors.lightGray5)
                    
            }
        }
        .padding(12)
        .bold()
    }
}
