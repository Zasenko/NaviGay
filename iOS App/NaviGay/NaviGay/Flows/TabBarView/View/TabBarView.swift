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
                //                Home(safeArea: safeArea, size: size)
                //                    .ignoresSafeArea(.container, edges: .top)
                switch viewModel.selectedPage {
                case .home:
                    Color.red
                case .user:
                    Color.red
                case .map:
                    MapView()
                        .ignoresSafeArea()
                case .catalog:
                    viewModel.cteateCatalogView(safeArea: safeArea, size: size)
                }
                tabBar
            }
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
