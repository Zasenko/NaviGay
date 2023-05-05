//
//  TabBarView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct TabBarView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: TabBarViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedItem) {
                ForEach(0..<viewModel.items.count, id: \.self) { index in
                    switch index {
                    case 0 :
                        viewModel.items[index].view
                            .tag(index)
                          //  .ignoresSafeArea()
                    default:
                        viewModel.items[index].view
                            .tag(index)
                    }
                }
            }
            tabBar
        }
    }
    
    private var tabBar: some View {
            HStack {
                ForEach(0..<viewModel.items.count, id: \.self) { index in
                    Button {
                        viewModel.buttonTappde(index: index)
                    } label: {
                        viewModel.items[index].img
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                            .padding()
                            .bold()
                    }
                    .foregroundColor(viewModel.selectedItem == index ? .red : AppColors.lightGray5)
                }
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.background)
        }
}

//struct TabView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView(viewModel: TabBarViewModel(isUserLogin: .constant(true)))
//    }
//}
