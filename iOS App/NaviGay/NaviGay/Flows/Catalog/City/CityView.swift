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
    
    var safeArea: EdgeInsets
    var size: CGSize
    
    let coordinateSpace: CoordinateSpace = .named("CityViewScroll")
    
    //MARK: - Body
    
    //    var body: some View {
    //        NavigationStack {
    //
    //            ScrollView {
    //                content
    //            }
    //            .edgesIgnoringSafeArea(.top)
    //            .navigationTitle(viewModel.city.name ?? "")
    //            //     .navigationBarBackButtonHidden(true)
    //            .toolbar {
    //                //                ToolbarItem(placement: .navigationBarLeading) {
    //                //                    HStack {
    //                //                        Text("!")
    //                //                            .bold()
    //                //                    }
    //                //                    .bold()
    //                //                }
    //                //
    //                ToolbarItem(placement: .principal) {
    //                    HStack {
    //                        Text(viewModel.city.name ?? "")
    //                            .foregroundStyle(AppColors.rainbowGradient)
    //                            .font(.largeTitle)
    //                    }
    //                    .bold()
    //                }
    //            }
    //        }
    //    }
    //
    //    private var content: some View {
    //        VStack {
    //
    //            ZStack {
    //                AsyncImage(url: URL(string: viewModel.city.photo ?? "")) { img in
    //                    img
    //                        .resizable()
    //                        .scaledToFill()
    //                        .edgesIgnoringSafeArea(.top)
    //
    //                } placeholder: {
    //                    ProgressView()
    //                }
    //
    //            }
    //
    //
    //
    //            Text(viewModel.city.about ?? "")
    //            if let places = viewModel.city.places?.allObjects as? [Place] {
    //                VStack {
    //                    ForEach(places) { place in
    //
    //                        Text(place.name ?? "")
    //                            .font(.headline)
    //                        AsyncImage(url: URL(string: place.photo ?? "")) { img in
    //                            img
    //                                .resizable()
    //                                .scaledToFill()
    //                                .frame(width: 100, height: 100)
    //                        } placeholder: {
    //                            ProgressView()
    //                                .frame(width: 100, height: 100)
    //                        }
    //                        Text(place.about ?? "")
    //                            .padding(.bottom)
    //
    //
    //
    //                    }
    //                }
    //            }
    //
    //        }
    //    }
    
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
                        .foregroundColor(.red)
                        .bold()
                }
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.red)
                        .bold()
                }
            }
            .overlay() {
                HStack {
                    Text(viewModel.city.name ?? "")
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
            
            viewModel.cityImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
                    .clipped()
            
            
//            AsyncImage(url: URL(string: viewModel.city.photo ?? ""), scale: 1) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
//                    .clipped()
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
//            .clipped()
            
            
            
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
        
        Text(viewModel.city.about ?? "")
        if let places = viewModel.city.places?.allObjects as? [Place] {
            VStack {
                ForEach(places) { place in
                    
                    Text(place.name ?? "")
                        .font(.headline)
                    AsyncImage(url: URL(string: place.photo ?? "")) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                    Text(place.about ?? "")
                        .padding(.bottom)
                    
                    
                    
                }
            }
        }
        
    }
    
}

//struct CityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityView()
//    }
//}
