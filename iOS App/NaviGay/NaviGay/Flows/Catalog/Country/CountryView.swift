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
    @Environment(\.dismiss) private var dismiss
    var safeArea: EdgeInsets
    var size: CGSize
    let coordinateSpace: CoordinateSpace = .named("CountryViewScroll")
    
    //MARK: - Body
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                photoView
                mainView
                .padding(.top, 10)
            }
            .overlay(alignment: .top) {
                headerView
            }
            
        }
        .coordinateSpace(name: "CountryViewScroll")
        .navigationBarHidden(true)
    }
    
    
    // MARK: - Header View
    
    var headerView: some View {
        GeometryReader{ proxy in
            let minY = proxy.frame(in: coordinateSpace).minY
            let height = size.height * 0.45
            //let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress =  minY / height
            
            HStack(spacing: 15) {
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()
                }
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .overlay() {
                HStack {
                    Text(viewModel.country.flag ?? "🏳️‍🌈")
                        .font(.title)
                    Text(viewModel.country.name ?? "")
                        .foregroundStyle(AppColors.rainbowGradient)
                        .font(.title)
                }
                .fontWeight(.semibold)
                .offset(y: -titleProgress > 1 ? 0 : 100)
                .clipped()
                .animation(.easeOut(duration: 0.25), value: -titleProgress > 1)
                .padding(.horizontal, 40)
            }
            .padding(.top, safeArea.top)// + 10)
            .padding()
            .background(
                // .ultraThinMaterial.opacity(-progress > 1 ? 1 : 0)
                .ultraThinMaterial.opacity(-titleProgress > 1 ? 1 : 0)
            )
            .offset(y: -minY)
            
        }
        //.frame(height: 35)
    }
    
    // MARK: - Photo View
    @ViewBuilder var photoView: some View {
        let height = size.height * 0.7
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: coordinateSpace).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            //            Image("hotel")
            //                .resizable()
            //                .aspectRatio(contentMode: .fill)
            //                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
            //                .clipped()
            viewModel.countryImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
                    .clipped()
           
                .overlay() {
                    
                    ZStack(alignment: .bottom) {
                        
                        // MARK: - Gradient Overlay
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    AppColors.background.opacity(0 - progress),
                                    AppColors.background.opacity(0.1 - progress),
                                    AppColors.background.opacity(0.3 - progress),
                                    AppColors.background.opacity(0.5 - progress),
                                    AppColors.background.opacity(0.8 - progress),
                                    AppColors.background.opacity(1),
                                ], startPoint: .top, endPoint: .bottom)
                            )

                        // MARK: - Info
                        VStack(spacing: 0) {
                            Text(viewModel.country.name ?? "")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("710,329 monthly listeners".uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.top, 15)
                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.bottom, 55)
                        
                        // Moving with Scroll View
                        .offset(y: minY < 0 ? minY : 0 )
                    }
                }
                .offset(y: -minY)
        }
        .frame(height: height + safeArea.top )
    }
    
    // MARK: - Main View
    
    @ViewBuilder var mainView: some View {
        VStack(spacing:  25) {
            if let regions = viewModel.country.regions?.allObjects as? [Region] {
                ForEach(regions) { region in
                    
                    Section {
                        if let cities = region.cities?.allObjects as? [City] {
                            VStack {
                                ForEach(cities) {city in
                                    NavigationLink {
                                        CityView(viewModel: CityViewModel(city: city, networkManager: viewModel.networkManager, dataManager: viewModel.dataManager), safeArea: safeArea, size: size)
                                    } label: {
                                        Text(city.name ?? "")
                                            .padding(.horizontal)
                                            .padding(.horizontal)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .background(AppColors.red.gradient)
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

        }
    }
}

//    struct CountryView_Previews: PreviewProvider {
//        static var previews: some View {
//            CountryView()
//        }
//    }
