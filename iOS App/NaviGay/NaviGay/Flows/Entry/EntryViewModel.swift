//
//  EntryViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

enum EntryViewRouter {
    case logoView
    case tabView
    case loginView
}

final class EntryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var router: EntryViewRouter = .logoView
    @Published var isUserLogin: Bool = false
    @Published var userStatus: UserStatus = .anonim
    
    // MARK: - Private Properties
    
    let userDataManager: UserDataManagerProtocol
    let networkManager = AuthNetworkManager(networkMonitor: NetworkMonitor(), api: ApiProperties())
    
    private let routerAnimation = Animation.spring()
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol) {
        self.userDataManager = userDataManager
    }
}

extension EntryViewModel {
    
    // MARK: - Functions
    
    @MainActor
    func checkUser() {
        Task {
            let result = await userDataManager.checkIsUserLogin()
            switch result {
            case .success(let bool):
                if bool {
                    isUserLogin = true
                    withAnimation(routerAnimation) {
                        self.router = .tabView
                    }
                } else {
                    withAnimation(routerAnimation) {
                        self.router = .loginView
                    }
                }
            case .failure(let error):
                //TODO!!!!
                debugPrint(error)
                withAnimation(routerAnimation) {
                    self.router = .logoView
                }
            }
        }
    }
}
