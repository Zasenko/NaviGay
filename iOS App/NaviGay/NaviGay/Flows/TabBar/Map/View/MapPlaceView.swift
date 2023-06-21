//
//  MapPlaceView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 19.06.23.
//

import SwiftUI

final class MapPlaceViewModel: ObservableObject {
    //MARK: - Properties
    
    @Published var place: Place
    @Published var placeImage: Image = AppImages.bw

    //MARK: - Inits
    
    init(place: Place) {
        self.place = place
        loadImage()
    }
}

extension MapPlaceViewModel {
    
    //MARK: - Private Functions
    
    func loadImage() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    private func loadFromCache() async {
        guard let urlString = place.photo else { return }
        do {
            self.placeImage = try await ImageLoader.shared.loadImage(urlString: urlString)
        }
        catch {
            //TODO
            print("ERROR -> PlaceViewModel loadFromCache(): ", error.localizedDescription)
        }
    }
}


struct MapPlaceView: View {
    
    // MARK: - Properties
    
//    let place: Place
//    @State private var placeImage: Image = AppImages.bw
    @ObservedObject var viewModel:  MapPlaceViewModel
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            viewModel.placeImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
//                    if viewModel.place {
//                        Image(systemName: "heart.fill")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.red)
//                    }
                    Text(viewModel.place.name ?? "")
                        .font(.headline)
                }
                .padding(.bottom, 4)
                Text(viewModel.place.address ?? "")
                    .font(.subheadline)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            .padding(.leading, 10)
            Spacer()
        }
//        .onChange(of: viewModel.place.id, perform: { newValue in
//            viewModel.loadImage()
//        })
        .onAppear() {
            viewModel.loadImage()
        }
    }
//
//    private func loadImage() {
//        Task {
//            await self.loadFromCache()
//        }
//    }
//    
//    @MainActor
//    private func loadFromCache() async {
//        guard let urlString = place.photo else { return }
//        do {
//            placeImage = try await ImageLoader.shared.loadImage(urlString: urlString)
//        }
//        catch {
//            //TODO
//            print("ERROR -> PlaceViewModel loadFromCache(): ", error.localizedDescription)
//        }
//    }
}

//struct MapPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPlaceView()
//    }
//}
