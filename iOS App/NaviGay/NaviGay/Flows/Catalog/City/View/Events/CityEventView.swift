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
            viewModel.eventImage
                    .resizable()
                    .scaledToFill()
                    .background(.regularMaterial)
                    .frame(width: (size.width / 2.5), height: ((size.width / 2.5) / 4) * 5)
                    .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: AppColors.shadow.opacity(0.3), radius: 8, x: 0, y: 3)
            
            .frame(width: (size.width / 2.5), height: ((size.width / 2.5) / 4) * 5)
            .padding()
            .background(Color.white)
            
            Text(viewModel.event.name ?? "")
                .font(.system(size: 17))
                .fontWeight(.heavy)
                .foregroundColor(.primary)

            Text(viewModel.eventStart)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(viewModel.event.finishTime?.formatted(date: .complete, time: .shortened) ?? "")
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
