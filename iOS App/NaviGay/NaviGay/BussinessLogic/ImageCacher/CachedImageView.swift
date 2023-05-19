//
//  CachedImageView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

struct CachedImageView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: CachedImageViewModel
    
    //MARK: - Body
    
    var body: some View {
                viewModel.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: viewModel.width, height: viewModel.height)
                                .clipped()
        
    }
}

//
//struct CachedImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CachedImageView()
//    }
//}
