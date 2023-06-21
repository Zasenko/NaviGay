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
//    var categories: [SortingMenuCategories] = [.all, .bar, .cafe, .club]
//    @State var selectedCategory: SortingMenuCategories = .all

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
                        .bold()
                    Image(systemName: "chevron.down")
                        .bold()
                        .foregroundColor(.black)
                        
                }
                .padding()
                .padding(.horizontal)
                .background(.thickMaterial)
                .clipShape(Capsule(style: .continuous))
            }
        }
    }
}

//struct MapSortingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSortingView()
//    }
//}
