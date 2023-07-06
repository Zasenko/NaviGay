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
            if isUserLoggedIn {
                
                guard lastLoginnedUserId != 0 else {
                    // lastLoginnedUserId nil
                    await MainActor.run {
                        print("--ERROR EntryViewModel checkUser() lastLoginnedUserId != 0 - false ")
                        withAnimation(routerAnimation) {
                            animationStarted = true
                            router = .loginView
                        }
                    }
                    return
                }
                
                guard let user = await userDataManager.findUser(id: lastLoginnedUserId) else {
                    // lastLoginnedUserId
                    await MainActor.run {
                        
                        withAnimation(routerAnimation) {
                            animationStarted = true
                            router = .loginView
                        }
                    }
                    return
                }
                
                let result = await login(user: user)
                if result {
                    await MainActor.run {
                        self.user = user
                        withAnimation(routerAnimation) {
                            animationStarted = true
                            router = .tabView
                        }
                    }
                } else {
                    await MainActor.run {
                        withAnimation(routerAnimation) {
                            animationStarted = true
                            router = .loginView
                        }
                    }
                }
                
    
            } else {
                // lastLoginnedUserId
                await MainActor.run {
                    
                    withAnimation(routerAnimation) {
                        animationStarted = true
                        router = .loginView
                    }
                }
            }
        }
    }
    
    private func login(user: User) async -> Bool {
        guard let email = user.email else {
            return false
        }
        do {
            let password = try keychinWrapper.getGenericPasswordFor(account: email, service: "User login")
            
            //смотря какой результат - если ошибка входа - сообщение об ошибке и логин вью, если нет сети - сообщить юзеру об этом и выполнить без входа
            let result = try await networkManager.login(email: email, password: password)
            
            if let error = result.errorDescription {
                debugPrint("EntryViewModel login(user: User) networkManager error: ", error)
                return false
            }
            
            guard let decodedUser = result.user else {
                return false
            }
            
            if await userDataManager.updateUser(user: user, decodedUser: decodedUser) {
                return true
            } else {
                return false
            }

        } catch {
            //смотря какой результат - если ошибка входа - сообщение об ошибке и переход на логин вью, если нет сети - сообщить юзеру об этом и выполнить без входа
            debugPrint("---ERROR EntryViewModel login(user: User): ", error)
        }
        return false
    }
}
