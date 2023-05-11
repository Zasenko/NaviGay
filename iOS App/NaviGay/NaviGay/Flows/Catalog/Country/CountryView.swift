//
//  CountryView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI
import CoreData

struct CountryView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CountryViewModel
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    AsyncImage(url: URL(string: viewModel.country.photo!), scale: 1) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .transition(.scale)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)


                    if let regions = viewModel.country.regions?.allObjects as? [Region] {
                      ForEach(regions) { region in
                          
                          Section {
                              if let cities = region.cities?.allObjects as? [City] {
                                  HStack {
                                      ForEach(cities) {city in
                                          
                                          
                                          NavigationLink {
                                              CityView(viewModel: CityViewModel(city: city, networkManager: viewModel.networkManager, dataManager: viewModel.dataManager))
                                          } label: {
                                              Text(city.name ?? "")
                                                  .padding(.horizontal)
                                                  .padding(.horizontal)
                                                  .frame(height: 50)
                                                  .background(AppColors.red)
                                                  .clipShape(Capsule(style: .continuous))
                                          }

                                          
                                          
                                          
                                      }
                                  }
                                  .padding(.bottom)
                              }
                          } header: {
                              Text(region.name ?? "")
                                  .font(.caption)
                                  .bold()
                          } footer: {}
                      }
                    }
                        
                    Text(viewModel.country.about ?? "")
                        .font(.body)
                        .padding()
                        .lineSpacing(10)
                        .foregroundColor(.secondary)
                    Text(viewModel.country.lastUpdate?.formatted(date: .complete, time: .complete) ?? "")
                    Text(viewModel.country.flag ?? "🏳️‍🌈")
                        .background(.yellow)
                }
                .padding(.bottom)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(viewModel.country.flag ?? "🏳️‍🌈")
                        .font(.title)
                    Text(viewModel.country.name ?? "")
                        .foregroundStyle(AppColors.rainbowGradient)
                        .font(.largeTitle)
                }
                .bold()
            }
        }
        //        .background {
        //            NavigationConfigurator { navigationConfigurator in
        //                navigationConfigurator.hidesBarsOnSwipe = true
        //                navigationConfigurator.hidesBottomBarWhenPushed = true
        //                navigationConfigurator.isToolbarHidden = true
        //                navigationConfigurator.toolbar.backgroundColor = .orange
        //            }
        //        }
    }
}
    
//    struct CountryView_Previews: PreviewProvider {
//        static var previews: some View {
//            CountryView()
//        }
//    }
