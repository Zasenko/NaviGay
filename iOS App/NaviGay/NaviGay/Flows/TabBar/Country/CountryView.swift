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
    
    let coordinateSpace: CoordinateSpace = .named("CountryViewScroll")
    
    @State private var photoViewTitleSize: CGSize = .zero
    @State private var showAbout: Bool = false
    
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
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
        .onChange(of: viewModel.country, perform: { newValue in
            print(newValue)
        })
        .coordinateSpace(name: coordinateSpace)
    }
    
    // MARK: - Header View
    
    @ViewBuilder private var headerView: some View {
        GeometryReader{ proxy in
            
            let minY = proxy.frame(in: coordinateSpace).minY
            
            HStack(spacing: 15) {
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    // .resizable()
                    //.scaledToFit()
                    // .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .bold()
                }
                Spacer()
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
                .offset(y: -minY > (viewModel.imageHeight - photoViewTitleSize.height) ? 0 : 100)
                .clipped()
                .animation(.easeOut(duration: 0.25), value: -minY > (viewModel.imageHeight - photoViewTitleSize.height))
                .padding(.horizontal, 40)
            }
            .padding(.top, viewModel.safeArea.top)
            .padding()
            .background(
                .ultraThinMaterial.opacity( -minY > (viewModel.imageHeight - photoViewTitleSize.height) ? 1 : 0)
            )
            .offset(y: -minY )
        }
    }
    
    // MARK: - Photo View
    @ViewBuilder private var photoView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: coordinateSpace).minY
            let progress = minY / (viewModel.imageHeight * (minY > 0 ? 0.5 : 0.8))
            
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.country.photo)) {
                AppColors.background
            }
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
                            .padding(.bottom, 50)
                    }
                    .opacity(1 + (progress > 0 ? -progress : progress))
                    .offset(y: minY < 0 ? minY : 0 )
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: SizePreferenceKey.self,
                                    value: proxy.size
                                )
                        }
                    )
                }
                .onPreferenceChange(SizePreferenceKey.self) { preferences in
                    self.photoViewTitleSize = preferences
                }
            }
            .offset(y: -minY)
        }
        .frame(height: viewModel.imageHeight + viewModel.safeArea.top )
    }
    
    // MARK: - Main View
    
    @ViewBuilder private var mainView: some View {
        VStack(spacing:  25) {
            Text(viewModel.country.about ?? "")
                .font(.body)
            //.lineSpacing(10)
                .lineLimit(showAbout ? nil : 4)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Button {
                withAnimation {
                    showAbout.toggle()
                }
            } label: {
                Text("Show more")
            }
            
            if let regions = viewModel.country.regions?.allObjects as? [Region] {
                ForEach(regions) { region in
                    VStack {
                        
                        Text(region.name ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .bold()
                        
                        if let cities = region.cities?.allObjects as? [City] {
                            VStack {
                                ForEach(cities) {city in
                                    NavigationLink {
                                        CityView(viewModel: CityViewModel(city: city, networkManager: viewModel.networkManager, dataManager: viewModel.dataManager, placeNetworkManager: viewModel.placeNetworkManager, placeDataManager: viewModel.placeDataManager), safeArea: viewModel.safeArea, size: viewModel.size)
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
                            .padding(.bottom, 10)
                        }
                        
                    }
                }
            }
            
            
            //  Text(viewModel.country.lastUpdate?.formatted(date: .complete, time: .complete) ?? "")
            
        }
    }
}

//    struct CountryView_Previews: PreviewProvider {
//        static var previews: some View {
//            CountryView()
//        }
//    }


struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
