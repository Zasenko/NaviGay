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
            
//            if let tags = viewModel.place.tags?.allObjects as? [Tag] {
//                HStack {
//                    VStack(alignment: .leading, spacing: 4) {
//                        ForEach(tags) {
//                            Text($0.name ?? "")
//                                .font(.caption)
//                                .bold()
//                                .foregroundColor(.secondary)
//                                .padding(10)
//                                .background(AppColors.lightGray6)
//                                .clipShape(Capsule())
//                        }
//                    }
//                    Spacer()
//                }
//            }
        }
    }
}

//struct CityPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPlaceView()
//    }
//}
