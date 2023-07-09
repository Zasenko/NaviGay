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
    
    @Environment(\.scenePhase) var scenePhase
    
    let dataManager: CoreDataManagerProtocol
    let userDataManager: UserDataManagerProtocol
    let authNetworkManager: AuthNetworkManagerProtocol
    let keychinWrapper: KeychainWrapperProtocol
    
    //MARK: - Inits
    
    init() {
        self.dataManager = CoreDataManager()
        self.userDataManager = UserDataManager(manager: dataManager, networkManager: UserDataNetworkManager())
        self.authNetworkManager = AuthNetworkManager()
        self.keychinWrapper = KeychainWrapper()
    }
    
    //MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            EntryView(viewModel: EntryViewModel(userDataManager: userDataManager, dataManager: dataManager, networkManager: authNetworkManager, keychinWrapper: keychinWrapper))
        }
//        .onChange(of: scenePhase) { _ in
//            Task {
//                try? await dataManager.save()
//            }
//        }
    }
}
