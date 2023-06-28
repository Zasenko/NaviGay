//
//  CityPlaceView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.05.23.
//

import SwiftUI

struct CityPlaceView: View {
    
    //MARK: - Proreties
    
    let place: Place
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                CachedImageView(viewModel: CachedImageViewModel(url: place.photo)) {
                    AppImages.iconPerson
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                }
                .background(.regularMaterial)
                .frame(width: 40, height: 40)
                .mask(Circle())
                .shadow(color: AppColors.shadow.opacity(0.3), radius: 3, x: 0, y: 1)
                .padding(10)
                
                Text(place.name ?? "")
                    .font(.body)
                    .bold()
                    .foregroundColor(.primary)
                    .padding()
                Spacer()
                AppImages.iconRight
                    .font(.title3)
                    .foregroundColor(AppColors.lightGray5)
            }
            Divider()
        }
        .padding(.horizontal)
    }
}
