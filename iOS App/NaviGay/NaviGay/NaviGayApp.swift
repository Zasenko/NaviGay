//
//  NaviGayApp.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import SwiftUI

@main
struct NaviGayApp: App {
    
    
    
    var body: some Scene {
        WindowGroup {
            EntryView(vm: EntryViewModel(userDataManager: UserDataManager(manager: CoreDataManager())))
        }
    }
}
