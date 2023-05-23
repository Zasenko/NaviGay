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
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                viewModel.placeImage
                    .resizable()
                    .scaledToFill()
                    .background(.regularMaterial)
                    .frame(width: (size.width / 2.5), height: ((size.width / 2.5) / 4) * 5)
                    .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: AppColors.shadow.opacity(0.3), radius: 8, x: 0, y: 3)
                Text(viewModel.place.name ?? "")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding()
            .background(Color.white)
            if let tags = viewModel.place.tags?.allObjects as? [PlaceTag] {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(tags) {
                            Text($0.name ?? "")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                                .padding(10)
                                .background(AppColors.lightGray6)
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

//struct CityPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPlaceView()
//    }
//}
