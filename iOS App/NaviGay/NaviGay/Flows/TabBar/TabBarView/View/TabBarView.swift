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
    @EnvironmentObject var viewBuilder: ViewBuilderManager

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
                        viewBuilder.buildCatalogView(safeArea: safeArea, size: size)
                    }
                    Spacer()
                }.ignoresSafeArea(.container, edges: .all)
                tabBar
            }.ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    private var tabBar: some View {
        HStack {
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.mapButton)
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.calendarButton)
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.catalogButton)
            TabBarButtonView(selectedPage: $viewModel.selectedPage, button: viewModel.userButton)
        }
    }
}
