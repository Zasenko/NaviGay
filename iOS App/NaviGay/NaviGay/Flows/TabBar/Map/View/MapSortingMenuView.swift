//
//  MapSortingMenuView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import SwiftUI

struct MapSortingMenuView: View {
        
    //MARK: - Properties
    
    @Binding var categories: [SortingMenuCategories]
    @Binding var selectedCategory: SortingMenuCategories
    let action: (SortingMenuCategories) -> Void

    //MARK: - Body
    
    var body: some View {
        VStack {
            Menu {
                ForEach(categories, id: \.self) { categoty in
                    Button {
                        action(categoty)
                        
                    } label: {
                        Text(categoty.getName())
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory.getName())
                        .font(.title2)
                    Image(systemName: "chevron.down")
                        .bold()
                        .foregroundColor(.black)
                        
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(.ultraThinMaterial)
                .clipShape(Capsule(style: .continuous))
                .padding(.horizontal)
            }
        }
    }
}

//struct MapSortingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSortingView()
//    }
//}
