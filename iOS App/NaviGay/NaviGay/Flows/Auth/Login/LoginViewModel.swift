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
    @Published var loginButtonState: AsyncButtonState = .normal
    @Published var invalidLoginAttempts = 0
    @Published var invalidPasswordAttempts = 0
    @Published var allViewsDisabled = false
    @Published var isSignUpViewOpen = false
    
    @Binding var entryRouter: EntryViewRouter
    @Binding var isUserLogin: Bool
    
    // MARK: - Private Properties
    
    let networkManager: AuthNetworkManagerProtocol
    let authManager: AuthManagerProtocol
    let userDataManager: UserDataManagerProtocol
    
    // MARK: - Inits
    
    init(networkManager: AuthNetworkManagerProtocol,authManager: AuthManagerProtocol, userDataManager: UserDataManagerProtocol, entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>) {
        self.networkManager = networkManager
        self.authManager = authManager
        self.userDataManager = userDataManager
        self._entryRouter = entryRouter
        self._isUserLogin = isUserLogin
    }
}

extension LoginViewModel {
    
    // MARK: - Functions
    
    @MainActor
    func loginButtonTapped() async {
        error = ""
        invalidLoginAttempts = 0
        invalidPasswordAttempts = 0
        allViewsDisabled = true
        authManager.checkEmailPassword(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                withAnimation(.easeInOut(duration: 0.5)) {
                    self?.loginButtonState = .loading
                }
                self?.login()
            case .failure(let error):
                self?.loginButtonState = .failure
                self?.returnToNormalState()
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
    private func login() {
        Task {
            do {
                let result = try await self.networkManager.login(email: email, password: password)
     
                if let error = result.errorDescription {
                    self.error = error
                    loginButtonState = .failure
                    returnToNormalState()
                }
                if let user = result.user {
                    loginButtonState = .success
                    await userDataManager.saveNewUser(decodedUser: user)
                    isUserLogin = true
                    toTabView()
                } else {
                    self.loginButtonState = .failure
                    returnToNormalState()
                }
            } catch {
                self.loginButtonState = .failure
                self.returnToNormalState()
            }
        }
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
