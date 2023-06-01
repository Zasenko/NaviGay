//
//  NaviGayApp.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import SwiftUI

@main
struct NaviGayApp: App {
    
    @StateObject var viewBuilder = ViewBuilderManager()

    var body: some Scene {
        WindowGroup {
            viewBuilder.buildEntryView()
                .environmentObject(viewBuilder)
        }
    }
}
