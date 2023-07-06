//
//  SignUpViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

final class SignUpViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var email = ""
    @Published var password = ""
    @Published var error = ""
    @Published var singUpButtonState: LoadState = .normal
    @Published var invalidLoginAttempts = 0
    @Published var invalidPasswordAttempts = 0
    @Published var allViewsDisabled = false
    
    @Binding var isSignUpViewOpen: Bool
    @Binding var entryRouter: EntryViewRouter
    @Binding var isUserLogin: Bool
    
    // MARK: - Private Properties
    
    private let networkManager: AuthNetworkManagerProtocol
    private let authManager: AuthManagerProtocol
    private let userDataManager: UserDataManagerProtocol
    private let keychinWrapper: KeychainWrapperProtocol
    // MARK: - Inits
    
    init(networkManager: AuthNetworkManagerProtocol,
         authManager: AuthManagerProtocol,
         userDataManager: UserDataManagerProtocol,
         keychinWrapper: KeychainWrapperProtocol,
         entryRouter: Binding<EntryViewRouter>,
         isUserLogin: Binding<Bool>,
         isSignUpViewOpen: Binding<Bool>) {
        self.networkManager = networkManager
        self.authManager = authManager
        self.userDataManager = userDataManager
        self.keychinWrapper = keychinWrapper
        _entryRouter = entryRouter
        _isUserLogin = isUserLogin
        _isSignUpViewOpen = isSignUpViewOpen
    }
}

extension SignUpViewModel {
    
    // MARK: - Functions
    
    func signUpButtonTapped() {
        error = ""
        invalidLoginAttempts = 0
        invalidPasswordAttempts = 0
        allViewsDisabled = true
        Task {
            await checkEmailPassword()
        }
    }
    
    func closeButtonTapped() {
        withAnimation(.spring()) {
            self.isSignUpViewOpen = false
        }
    }
    
    // MARK: - Private Functions
    
    @MainActor
    private func checkEmailPassword() async {
        authManager.checkEmailPassword(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.changeLoginButtonState(state: .loading)

                self?.registration()
            case .failure(let error):
                self?.changeLoginButtonState(state: .failure)
                self?.returnToNormalState()
                switch error {
                case .emptyEmail:
                    self?.error = "empty email"
                    self?.shakeLogin()
                case .wrongEmail:
                    self?.error = "Incorrect email"
                    self?.shakeLogin()
                case .emptyPassword:
                    self?.error = "emptyPassword"
                    self?.shakePassword()
                case .noLowercase:
                    self?.error = "Wrong password noLowercase"
                    self?.shakePassword()
                case .noMinCharacters:
                    self?.error = "Wrong password noMinCharacters"
                    self?.shakePassword()
                case .noDigit:
                    self?.error = "Wrong password noDigit"
                    self?.shakePassword()
                default:
                    self?.error = "Wrong email or password"
                    self?.shakePassword()
                }
            }
        }
    }
    
    @MainActor
    private func registration() {
        Task {
            do {
                let result = try await networkManager.registration(email: email, password: password)
                if let error = result.errorDescription {
                    self.error = error
                    changeLoginButtonState(state: .failure)
                    returnToNormalState()
                    return
                }
                guard let user = result.user else {
                    changeLoginButtonState(state: .failure)
                    returnToNormalState()
                    return
                }
                try await userDataManager.saveNewUser(decodedUser: user)
                try keychinWrapper.storeGenericPasswordFor(account: email, service: "User login", password: password)
                singUpButtonState = .success
                isUserLogin = true
                toTabView()
            } catch {
                changeLoginButtonState(state: .failure)
                returnToNormalState()
            }
        }
    }
    
    private func changeLoginButtonState(state: LoadState) {
        withAnimation(.spring()) {
            self.singUpButtonState = state
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.singUpButtonState = .normal
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
