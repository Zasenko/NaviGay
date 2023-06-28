//
//  PlaceView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import SwiftUI

struct PlaceView: View {
    //MARK: - Proreties
    
    @StateObject var viewModel: PlaceViewModel
    @Environment(\.dismiss) private var dismiss
    
    let safeArea: EdgeInsets
    let size: CGSize
    let coordinateSpace: CoordinateSpace = .named("PlaceViewScroll")
    
    @State private var photoViewTitleSize: CGSize = .zero
    
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
        GeometryReader{ proxy in
            
            let minY = proxy.frame(in: coordinateSpace).minY
            let height = (size.width / 4 ) * 5 ///высота картинки
            
            HStack(spacing: 15) {
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .bold()
                }
                Spacer()
                
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .overlay() {
                Text(viewModel.place.name ?? "")
                    .foregroundStyle(AppColors.rainbowGradient)
                    .font(.title)
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
            .offset(y: -minY )
        }
    }
    
    // MARK: - Photo View
    @ViewBuilder private var photoView: some View {
        let height = (size.width / 4 ) * 5
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: coordinateSpace).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.place.photo)) {
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
                            Text(viewModel.place.name ?? "")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text(viewModel.place.type?.uppercased() ?? "")
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
        .frame(height: height + safeArea.top )
    }
    
    // MARK: - Main View
    
    @ViewBuilder private var mainView: some View {
        VStack(spacing:  25) {
            
            VStack {
                Text(viewModel.place.address ?? "")
                Text(viewModel.place.about ?? "")
                Text(viewModel.place.fb ?? "")
                Text(viewModel.place.insta ?? "")
                Text(viewModel.place.phone ?? "")
                Text(viewModel.place.www ?? "")
                Text(viewModel.place.address ?? "")
            }
            .font(.body)
            .lineLimit(nil)
            .foregroundColor(.secondary)
            .padding(.horizontal)
            
            if let photos = viewModel.place.photos?.allObjects as? [Photo] {
                ForEach(photos) { photo in
                    
                    AsyncImage(url: URL(string: photo.url!)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 300)
                    } placeholder: {
                        Color.red
                            .frame(width: 100, height: 300)
                    }
                }
            }
            
            ForEach(viewModel.place.workingTimes?.allObjects as? [WorkingTime] ?? []) { time in
                
                HStack(spacing: 10) {
                    Text(time.day ?? "")
                    Text(time.open ?? "")
                    Text(time.close ?? "")
                }
            }
            
            ForEach(viewModel.place.tags?.allObjects as? [Tag] ?? []) { tag in
                Text(tag.name ?? "")
                    .padding()
                    .background(.yellow)
                
            }
            
            ForEach(viewModel.place.comments?.allObjects as? [PlaceComment] ?? []) { comment in
                VStack(spacing: 10) {
                    Text(comment.createdAt ?? "")
                    Text(comment.userPhoto ?? "")
                    Text(comment.userName ?? "")
                    Text(comment.text ?? "")
                }
                .padding()
                .background(.orange)
                
            }
        }
    }
}

//struct PlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceView()
//    }
//}
