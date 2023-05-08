//
//  CitiesView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 08.05.23.
//

import SwiftUI

struct CitiesView: View {
    
    @StateObject var viewModel: CitiesViewModel
    
    var body: some View {
        LazyVStack {
            ForEach(viewModel.cities ) { city in
                Text(city.name ?? "")
                    .background(.orange)
            }
        }
    }
    
}

//struct CitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CitiesView()
//    }
//}
