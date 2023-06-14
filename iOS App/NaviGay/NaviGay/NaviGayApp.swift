//
//  NaviGayApp.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import SwiftUI

@main
struct NaviGayApp: App {
    
    //MARK: - Properties
    
    let dataManager: CoreDataManagerProtocol
    let userDataManager: UserDataManagerProtocol
    let authNetworkManager: AuthNetworkManagerProtocol
    
    //MARK: - Inits
    
    init() {
        self.dataManager = CoreDataManager()
        self.userDataManager = UserDataManager(manager: dataManager)
        self.authNetworkManager = AuthNetworkManager()
    }
    
    //MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            EntryView(viewModel: EntryViewModel(userDataManager: userDataManager, dataManager: dataManager, networkManager: authNetworkManager))
        }
    }
}
