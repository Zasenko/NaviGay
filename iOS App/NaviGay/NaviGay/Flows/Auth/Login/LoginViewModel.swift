//
//  LoginViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var email = ""
    @Published var password = ""
    @Published var error = ""
    @Published var loginButtonState: LoadState = .normal
    @Published var invalidLoginAttempts = 0
    @Published var invalidPasswordAttempts = 0
    @Published var allViewsDisabled = false
    @Published var isSignUpViewOpen = false
    
    @Binding var entryRouter: EntryViewRouter
    @Binding var isUserLogin: Bool
    
    let userDataManager: UserDataManagerProtocol
    let networkManager: AuthNetworkManagerProtocol
    let authManager: AuthManagerProtocol
        
    // MARK: - Inits
    
    init(entryRouter: Binding<EntryViewRouter>,
         isUserLogin: Binding<Bool>,
         userDataManager: UserDataManagerProtocol,
         networkManager: AuthNetworkManagerProtocol,
         authManager: AuthManagerProtocol) {
        self.userDataManager = userDataManager
        self.networkManager = networkManager
        self.authManager = authManager
        _entryRouter = entryRouter
        _isUserLogin = isUserLogin
    }
}

extension LoginViewModel {
    
    // MARK: - Functions
    
    func loginButtonTapped() {
        error = ""
        invalidLoginAttempts = 0
        invalidPasswordAttempts = 0
        allViewsDisabled = true
        Task {
            await checkEmailPassword()
        }
    }
    
    func skipButtonTapped() {
        withAnimation(.spring()) {
            self.entryRouter = .tabView
        }
    }
    
    func signUpButtonTapped() {
        withAnimation(.spring()) {
            self.isSignUpViewOpen = true
        }
    }
    
    // MARK: - Private Functions
    
    @MainActor
    private func checkEmailPassword() async {
        authManager.checkEmailPassword(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.changeLoginButtonState(state: .loading)
                self?.login()
            case .failure(let error):
                self?.changeLoginButtonState(state: .failure)
                switch error {
                case .wrongEmail, .emptyEmail:
                    self?.error = "Incorrect email"
                    self?.shakeLogin()
                    return
                case .emptyPassword, .noDigit, .noLowercase, .noMinCharacters:
                    self?.error = "Wrong password"
                    self?.shakePassword()
                    return
                default:
                    self?.error = "Wrong email or password"
                    self?.shakePassword()
                    return
                }
            }
        }
    }
    
    @MainActor
    private func login() {
        Task {
            do {
                let result = try await self.networkManager.login(email: email, password: password)
                if let error = result.errorDescription {
                    self.error = error
                    self.changeLoginButtonState(state: .failure)
                }
                if let user = result.user {
                    loginButtonState = .success
                    await userDataManager.saveNewUser(decodedUser: user)
                    isUserLogin = true
                    toTabView()
                } else {
                    self.changeLoginButtonState(state: .failure)
                }
            } catch {
                self.changeLoginButtonState(state: .failure)
            }
        }
    }
    
    private func changeLoginButtonState(state: LoadState) {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.loginButtonState = state
        }
        self.returnToNormalState()
    }
    
    private func shakeLogin() {
        withAnimation(.default) {
            invalidLoginAttempts += 1
        }
    }
    
    private func shakePassword() {
        withAnimation(.default) {
            invalidPasswordAttempts += 1
        }
    }
    
    private func returnToNormalState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.loginButtonState = .normal
                self.allViewsDisabled = false
            }
        }
    }
    
    private func toTabView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.spring()) {
                self.entryRouter = .tabView
            }
        }
    }
}
