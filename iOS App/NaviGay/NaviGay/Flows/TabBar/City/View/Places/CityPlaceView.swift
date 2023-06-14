//
//  CityPlaceView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.05.23.
//

import SwiftUI

struct CityPlaceView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CityPlaceViewModel
    
    let size: CGSize
    let safeArea: EdgeInsets
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            NavigationLink {
                //viewBuilder.buildPlaceView(place: viewModel.place, safeArea: safeArea, size: size)
            } label: {
                HStack(alignment: .center) {
                    viewModel.placeImage
                        .resizable()
                        .scaledToFill()
                        .background(.regularMaterial)
                        .frame(width: 50, height: 50)
                        .mask(Circle())
                        .shadow(color: AppColors.shadow.opacity(0.3), radius: 8, x: 0, y: 3)
                    Text(viewModel.place.name ?? "")
                        .font(.body)
                        .bold()
                        .foregroundColor(.primary)
                        .padding()
                }
                .padding()
                .background(Color.white)
            }
        }
    }
}

//struct CityPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPlaceView()
//    }
//}
