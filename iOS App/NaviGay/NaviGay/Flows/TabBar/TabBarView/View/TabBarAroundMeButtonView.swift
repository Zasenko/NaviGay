//
//  TabBarAroundMeButtonView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import SwiftUI

struct TabBarAroundMeButtonView: View {
    
    // MARK: - Properties
    
    let tabBarButton: TabBarButton
    @Binding var selectedPage: TabBarRouter
    @Binding var aroundMeSelectedPage: AroundMeRouter
    
    // MARK: - Private Properties
    
    private let mapButton = TabBarAroundMeButton(title: "Map", img: AppImages.iconMap, page: .map)
    private let homeButton = TabBarAroundMeButton(title: "Home", img: AppImages.iconCalendar, page: .home)
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                selectedPage = tabBarButton.page
                aroundMeSelectedPage = .home
            } label: {
                homeButton.img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedPage == .aroundMe && aroundMeSelectedPage == homeButton.page ? AppColors.red : AppColors.lightGray5)
                    .padding(.horizontal, 12)
                    .bold()
            }
            Button {
                selectedPage = tabBarButton.page
                aroundMeSelectedPage = .map
            } label: {
                mapButton.img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedPage == .aroundMe && aroundMeSelectedPage == mapButton.page ? AppColors.red : AppColors.lightGray5)
                    .padding(.horizontal, 12)
                    .bold()
            }
        }
    }
}

//struct TabBarAroundMeButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarAroundMeButtonsView()
//    }
//}
//
//
