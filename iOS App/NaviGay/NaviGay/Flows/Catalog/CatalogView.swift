//
//  CatalogView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import SwiftUI

struct CatalogView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CatalogViewModel
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                
                switch viewModel.loadState {
                case .normal, .success:
                    Section {
                        Color.clear
                            .frame(height: 20)
                            .listRowSeparator(.hidden)
                    }
                    Section {
                        ForEach(viewModel.activeCountries) { country in
                            NavigationLink {
                                CountryView(viewModel: CountryViewModel(country: country, networkManager: viewModel.networkManager, dataManager: viewModel.dataManager))
                            } label: {
                                CountryCell(country: country)
                            }
                        }
                        .listRowBackground(AppColors.background)
                    }
                case .loading:
                    ProgressView()
                case .failure:
                    Text("что-то пошло не так")
                }
                
                
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Countries")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(AppColors.rainbowGradient)
                }
            }
            .navigationTitle("")
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .background(
                Color.clear
                //                    NavigationConfigurator { navigationConfigurator in
                //                        navigationConfigurator.hidesBarsOnSwipe = true
                //                     //   navigationConfigurator.hidesBottomBarWhenPushed = false
                //                     //   navigationConfigurator.isToolbarHidden = true
                //                     //   navigationConfigurator.toolbar.backgroundColor = .orange
                //                    }
            )
        }
    }
    
    //MARK: - Views
    //    @ViewBuilder private var listWithCountries: some View {
    //        List {
    //            Section {
    //                Color.clear
    //                    .frame(height: 20)
    //                    .listRowSeparator(.hidden)
    //            }
    //            Section {
    //                ForEach($viewModel.countries) { country in
    //                    NavigationLink {
    //                        viewModel.makeCountryView(country: country)
    //                    } label: {
    //                        CountryCell(country: country)
    //                    }
    //                }
    //                .listRowBackground(AppColors.background)
    //            }
    //        }
    //        .listStyle(.plain)
    //        .onAppear() {
    //            viewModel.getCountries()
    //        }
    //    }
}

//struct CatalogView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatalogView()
//    }
//}
