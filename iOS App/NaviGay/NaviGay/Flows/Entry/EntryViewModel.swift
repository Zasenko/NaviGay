//
//  EntryViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

final class EntryViewModel: ObservableObject {
    
    enum EntryViewRouter {
        case logoView
        case tabView
        case loginView
    }
    
    // MARK: - Properties
    
    @Published var router: EntryViewRouter = .logoView
    //@Published var isUserLogin: Bool = false
    
    // MARK: - Private Properties
    
    private let userDataManager: UserDataManagerProtocol
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
                    withAnimation(routerAnimation) {
                        self.router = .tabView
                    }
                } else {
                    withAnimation(routerAnimation) {
                        self.router = .loginView
                    }
                }
            case .failure(let error):
                debugPrint(error)
                withAnimation(routerAnimation) {
                    self.router = .logoView
                }
            }
        }
    }
}
