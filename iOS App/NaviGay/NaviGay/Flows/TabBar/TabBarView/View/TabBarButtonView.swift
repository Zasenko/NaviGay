//
//  TabBarButtonView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

struct TabBarButtonView : View {
    
    // MARK: - Properties
    
    @Binding var selectedPage: TabBarRouter
    let button: TabBarButton
    
    // MARK: - Body
    
    var body: some View{
        Button {
            selectedPage = button.page
        } label: {
            button.img
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(selectedPage == button.page ? AppColors.red : AppColors.lightGray5)
                .padding(.horizontal, 12)
                .bold()
        }
    }
}

//struct TabBarButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarButtonView()
//    }
//}
