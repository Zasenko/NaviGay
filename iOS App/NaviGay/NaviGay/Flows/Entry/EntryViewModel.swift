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
    
    let api: ApiProperties
    let userDataManager: UserDataManagerProtocol
    let dataManager: CoreDataManagerProtocol
    
    // MARK: - Private Properties
    
//    
//    lazy var authNetworkManager = AuthNetworkManager(networkMonitor: networkMonitor, api: api)
//    lazy var catalogNetworkManager = CatalogNetworkManager(networkMonitor: networkMonitor, api: api)
    
    private let routerAnimation = Animation.spring()
    
    // MARK: - Inits
    
    init() {
        self.api = ApiProperties()
        self.dataManager = CoreDataManager()
        self.userDataManager = UserDataManager(manager: dataManager)
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
