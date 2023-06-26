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
    
    let userDataManager: UserDataManagerProtocol
    let dataManager: CoreDataManagerProtocol
    
    // MARK: - Private Proparties
    
    private let routerAnimation = Animation.spring()
    private let networkManager: AuthNetworkManagerProtocol
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol, dataManager: CoreDataManagerProtocol, networkManager: AuthNetworkManagerProtocol) {
        self.userDataManager = userDataManager
        self.networkManager = networkManager
        self.dataManager = dataManager
        checkUser()
    }
}

extension EntryViewModel {
    
    // MARK: - Private Functions
    
    private func checkUser() {
        Task {
            let result = await userDataManager.checkIsUserLogin()
            await MainActor.run {
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
                }
            }
        }
    }
}
