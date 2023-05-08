//
//  CountryView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

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

                    
                    
                    //   BView(country: viewModel.$country, geometrySize: geometry.size)
                    
                    
                    
                    Text(viewModel.country.about ?? "")
                        .font(.body)
                        .padding()
                    //    .lineSpacing(12)
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
                    Text("\(viewModel.country.flag ?? "🏳️‍🌈")")
                        .font(.title)
                    Text("\(viewModel.country.name ?? "")")
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
    
    
//    struct BView: View {
//
//        @Binding var country:  Country
//        var geometrySize: CGSize
//
//        var body: some View {
//
//            var width = CGFloat.zero
//            var height = CGFloat.zero
//
//            return ZStack(alignment: .topLeading) {
//                ForEach($country.) { city in
//                    CityViewTest(city: city)
//                        .alignmentGuide(.leading, computeValue: { d in
//                            if (abs(width - d.width) > geometrySize.width)
//                            {
//                                width = 0
//                                height -= d.height
//                            }
//                            let result = width
//                            if city.id == country.cities.last?.id {
//                                width = 0 //last item
//                            } else {
//                                width -= d.width
//                            }
//                            return result
//                        })
//                        .alignmentGuide(.top, computeValue: { d in
//                            let result = height
//                            if city.id == country.cities.last?.id {
//                                height = 0 // last item
//                            }
//                            return result
//                        })
//                }
//            }
//        }
//    }
//}
//
//struct CityViewTest: View {
//
//    @Binding var city: City
//
//    var body: some View {
//        Text(city.name)
//                                    .bold()
//                                    .foregroundColor(.white)
//                                    .lineLimit(1)
//                                    .padding(.horizontal)
//                                    .padding(.horizontal)
//                                    .frame(height: 50)
//                                    .background(AppColors.red)
//                                    .clipShape(Capsule(style: .continuous))
//                                    .padding(4)
//    }
//}
