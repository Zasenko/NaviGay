//
//  EntryViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

enum EntryViewRouter {
    case tabView
    case loginView
}

final class EntryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var router: EntryViewRouter = .loginView
    @Published var animationStarted: Bool = false
    @Published var animationFinished: Bool = false
    @Published var user: User? = nil
    
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false
    @AppStorage("lastLoginnedUserId") var lastLoginnedUserId: Int = 0
    
    let userDataManager: UserDataManagerProtocol
    let dataManager: CoreDataManagerProtocol
    let keychinWrapper: KeychainWrapperProtocol
    
    // MARK: - Private Proparties
    
    private let routerAnimation = Animation.spring()
    private let networkManager: AuthNetworkManagerProtocol
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol,
         dataManager: CoreDataManagerProtocol,
         networkManager: AuthNetworkManagerProtocol,
         keychinWrapper: KeychainWrapperProtocol) {
        self.userDataManager = userDataManager
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.keychinWrapper = keychinWrapper
        checkUser()
    }
}

extension EntryViewModel {
    
    // MARK: - Private Functions
    
    private func checkUser() {
        Task {
            guard isUserLoggedIn == true else {
                await goToView(router: .loginView)
                return
            }
            guard lastLoginnedUserId != 0 else {
                await goToView(router: .loginView)
                return
            }
            
            do {
                let user = try await userDataManager.findUser(id: lastLoginnedUserId)
                if let user = user {
                    try await login(user: user)
                    await goToView(router: .tabView)
                } else {
                    await goToView(router: .loginView)
                }
            } catch {
                debugPrint("---ERROR--- EntryViewModel checkUser: ", error)
                await goToView(router: .loginView)
            }
        }
    }
    
    private func login(user: User) async throws {
        guard let email = user.email else {
            throw CoreDataManagerError.userDidntHasEmail
        }
        do {
            let password = try keychinWrapper.getGenericPasswordFor(account: email, service: "User login")
            let result = try await networkManager.login(email: email, password: password)
            
            if result.error != nil {
                if let errorDescription = result.errorDescription {
                    throw NetworkErrors.apiErrorWithMassage(errorDescription)
                } else {
                    throw NetworkErrors.apiError
                }
            }
            guard let decodedUser = result.user else {
                throw NetworkErrors.noUser
            }
            try await userDataManager.updateUser(user: user, decodedUser: decodedUser)
            try await userDataManager.save()
            
            await MainActor.run(body: {
                self.user = user
            })
        } catch {
            throw error
        }
    }
    
    private func goToView(router: EntryViewRouter) async {
        await MainActor.run {
            withAnimation(routerAnimation) {
                if router == .loginView {
                    isUserLoggedIn = false
                }
                animationStarted = true
                self.router = router
            }
        }
    }
}
