//
//  AppColors.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct AppColors {
    static let red = Color("red")
    static let background = Color(uiColor: UIColor.systemBackground)
    static let lightGray6 = Color(UIColor.systemGray6)
    static let lightGray5 = Color(UIColor.systemGray5)
    static let shadow = Color("shadow")
    
    static let rainbowGradient = LinearGradient(
        colors: [.red, .blue, .green, .yellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}
