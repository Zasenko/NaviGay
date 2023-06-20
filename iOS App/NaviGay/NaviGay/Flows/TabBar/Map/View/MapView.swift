//
//  MapView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

struct MapView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: MapViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ZStack {
                UIKitMapView(mapViewModel: viewModel)
                    .ignoresSafeArea(.container, edges: .all)
                view
            }
            if viewModel.showInfoSheet {
                if let place = viewModel.selectedPlace {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            HStack(alignment: .top) {
//                                //                    if viewModel.place {
//                                //                        Image(systemName: "heart.fill")
//                                //                            .resizable()
//                                //                            .frame(width: 20, height: 20)
//                                //                            .foregroundColor(.red)
//                                //                    }
//                                Text(place.name ?? "")
//                                    .font(.headline)
//                                Text(place.type ?? "")
//                            }
//                            .padding(.bottom, 4)
//                            Text(place.address ?? "")
//                                .font(.subheadline)
//                        }
//                        .multilineTextAlignment(.leading)
//                        .foregroundColor(.black)
//                        .padding(.leading, 10)
//
//                        Spacer()
//                    }
                    MapPlaceView(viewModel: MapPlaceViewModel(place: place))
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge: .bottom),
                                            removal: .opacity))
                   // .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
//        .sheet(isPresented: $viewModel.showPlaceSheet) {
//            ZStack {
//                Color.yellow.edgesIgnoringSafeArea(.all)
//                VStack {
//                    HStack {
//                        AppImages.iconPerson
//                            .frame(width: 40, height: 40)
//                        Text("Hello from the SwiftUI sheet!")
//                    }
//
//                    Text("Bla bla bla")
//
//                }
//                .padding()
//            }
//            .presentationDetents([.height(150), .medium])
//            .presentationDragIndicator(.visible)
//            .edgesIgnoringSafeArea(.all)
//        }
    }
    
    private var view: some View {
        VStack {
            Text("All Places")
                .bold()
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
