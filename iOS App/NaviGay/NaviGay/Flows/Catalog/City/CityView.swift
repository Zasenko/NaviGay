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
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                    VStack {
                        
                        AsyncImage(url: URL(string: viewModel.city.photo ?? "")) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 100, height: 100)
                        
                        Text(viewModel.city.about ?? "")
                        
                        

                    }
                    
            }
            .navigationTitle(viewModel.city.name ?? "")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("!")
                            .bold()
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(viewModel.city.name ?? "")
                            .foregroundStyle(AppColors.rainbowGradient)
                            .font(.largeTitle)
                    }
                    .bold()
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
