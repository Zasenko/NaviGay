//
//  CityView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 11.05.23.
//

import SwiftUI

struct CityView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CityViewModel
    @Environment(\.dismiss) private var dismiss
    
    let safeArea: EdgeInsets
    let size: CGSize
    let coordinateSpace: CoordinateSpace = .named("CityViewScroll")
    
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
        .coordinateSpace(name: coordinateSpace)
        .navigationBarHidden(true)
    }
    
    
    // MARK: - Header View
    
    @ViewBuilder private var headerView: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: coordinateSpace).minY
            let height = (size.width / 4 ) * 5 ///высота картинки
            
            HStack(spacing: 15) {
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.red)
                        .bold()
                }
                Spacer()
            }
            .overlay() {
                HStack {
                    Text(viewModel.city.name ?? "")
                        .foregroundStyle(AppColors.rainbowGradient)
                        .font(.title)
                }
                .fontWeight(.semibold)
                .offset(y: -minY > (height - photoViewTitleSize.height) ? 0 : 100)
                .clipped()
                .animation(.easeOut(duration: 0.25), value: -minY > (height - photoViewTitleSize.height))
                .padding(.horizontal, 40)
            }
            .padding(.top, safeArea.top)
            .padding()
            .background(
                .ultraThinMaterial.opacity( -minY > (height - photoViewTitleSize.height) ? 1 : 0)
            )
            .offset(y: -minY)
            
        }
    }
    
    // MARK: - Photo View
    @ViewBuilder private var photoView: some View {
        let height = (size.width / 4 ) * 5
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: coordinateSpace).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.city.photo)) {
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
                        Text(viewModel.city.name ?? "")
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
        .frame(height: height + safeArea.top )
    }
    
    // MARK: - Main View
    
    @ViewBuilder private var mainView: some View {
        
        VStack(alignment: .leading) {
            ForEach(viewModel.sortedKeys, id: \.self) { key in
                Section {
                    ForEach(viewModel.sortedDictionary[key] ?? []) { place in
                        NavigationLink {
                            PlaceView(viewModel: PlaceViewModel(place: place, networkManager: viewModel.placeNetworkManager, dataManager: viewModel.placeDataManager), safeArea: safeArea, size: size)
                        } label: {
                            CityPlaceView(place: place)
                        }
                    }
                } header: {
                    Text(key.uppercased())
                        .foregroundColor(.secondary)
                        .fontWeight(.light)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.top)
                } footer: {}
            }
        }
        Text(viewModel.city.about ?? "")
        
        VStack(alignment: .leading) {
            ForEach(viewModel.events.filter({ $0.isActive == true }), id: \.id) { event in
                CityEventView(viewModel: CityEventViewModel(event: event), size: size)
            }
        }
    }
}

//struct CityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityView()
//    }
//}
