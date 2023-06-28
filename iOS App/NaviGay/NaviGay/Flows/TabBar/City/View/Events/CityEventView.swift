//
//  CityEventView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import SwiftUI

struct CityEventView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CityEventViewModel
    
    let size: CGSize
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.event.cover)) {
                AppColors.background
            }
            .background(.regularMaterial)
            .frame(width: (size.width / 2.5), height: ((size.width / 2.5) / 4) * 5)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(Color.white)
            .shadow(color: AppColors.shadow.opacity(0.3), radius: 8, x: 0, y: 3)
            if viewModel.isPartyFinished {
                AppColors.red
                    .frame(width: 100, height: 100)
            }
            
            
            Text(viewModel.event.type ?? "")
                .font(.system(size: 30))
                .fontWeight(.heavy)
                .foregroundColor(viewModel.isPartyFinished ? .secondary : .primary)
            
            Text(viewModel.event.name ?? "")
                .font(.system(size: 17))
                .fontWeight(.heavy)
                .foregroundColor(.primary)
            
            Text(viewModel.startTime)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(viewModel.finishTime)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(viewModel.event.startTime?.formatted(date: .complete, time: .shortened) ?? "st---")
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Text(viewModel.event.finishTime?.formatted(date: .complete, time: .shortened) ?? "ft---")
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
        }
    }
}

//struct CityEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityEventView()
//    }
//}
