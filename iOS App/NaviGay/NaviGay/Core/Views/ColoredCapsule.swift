//
//  ColoredCapsule.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 26.06.23.
//

import SwiftUI

struct ColoredCapsule<Content: View>: View {
    
    let content: () -> Content
    let background: Color
    
    init(background: Color, @ViewBuilder content: @escaping () -> Content) {
        self.background = background
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(10)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(background.gradient)
            .clipShape(Capsule(style: .continuous))
    }
}
