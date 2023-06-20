//
//  AddPlaceView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 20.06.23.
//

import SwiftUI

struct AddPlaceView: View {
    
    @StateObject var viewModel = AddPlaceViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                TextField("name", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("about", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("name", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}
