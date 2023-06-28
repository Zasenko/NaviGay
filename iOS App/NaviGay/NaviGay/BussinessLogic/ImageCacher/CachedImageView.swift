//
//  CachedImageView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

struct CachedImageView<Content>: View where Content: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: CachedImageViewModel
    let content: () -> Content
    
    //MARK: - Body
    
    var body: some View {
        if let image = viewModel.image {
            image
                .resizable()
                .scaledToFill()
        } else {
            content()
        }
    }
}
