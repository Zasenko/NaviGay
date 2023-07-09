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
    
    @Binding var isUserLoggedIn: Bool
    @Binding var lastLoginnedUserId: Int
    @Binding var user: User?
    
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
         lastLoginnedUserId: Binding<Int>,
         isSignUpViewOpen: Binding<Bool>,
         user: Binding<User?>,
         isUserLoggedIn: Binding<Bool>) {
        self.networkManager = networkManager
        self.authManager = authManager
        self.userDataManager = userDataManager
        self.keychinWrapper = keychinWrapper
        _entryRouter = entryRouter
        _isUserLoggedIn = isUserLoggedIn
        _isSignUpViewOpen = isSignUpViewOpen
        _lastLoginnedUserId = lastLoginnedUserId
        _user = user
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
    
    //ok
    @MainActor
    private func checkEmailPassword() async {
        do {
            try await authManager.checkEmailAndPassword(email: email, password: password)
            try await registration()
            singUpButtonState = .success
            toTabView()
        } catch AuthManagerErrors.emptyEmail {
            self.error = "Empty email."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.wrongEmail {
            self.error = "Wrong email."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.emptyPassword {
            self.error = "Wrong password - emptyPassword."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.noDigit {
            self.error = "Wrong password - noDigit."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.noLowercase {
            self.error = "Wrong password - noLowercase."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.noMinCharacters {
            self.error = "Wrong password - noMinCharacters."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.noUppercase {
            self.error = "Wrong password - noUppercase."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        }
            // TODO!!!! NetworkErrors. нет подключения к интернету
            // TODO!!!! NetworkErrors.apiErrorWithMassage(errorDescription)
        
//        catch NetworkErrors.apiErrorWithMassage {
//            self.error = error.
//            changeLoginButtonState(state: .failure)
//            returnToNormalState()
//        }
        catch {
            self.error = "--- ERROR --- : \(error)"
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        }
    }
    
    //ok
    private func registration() async throws {
            do {
                let result = try await networkManager.login(email: email, password: password)
                if result.error != nil {
                    if let errorDescription = result.errorDescription {
                        throw NetworkErrors.apiErrorWithMassage(errorDescription)
                    } else {
                        throw NetworkErrors.apiError
                    }
                }
                guard let decodedUser = result.user, decodedUser.email != nil else {
                    throw NetworkErrors.noUser
                }
                let newUser = await userDataManager.createEmptyUser(decodedUser: decodedUser)
                try await userDataManager.save()
                try keychinWrapper.storeGenericPasswordFor(account: email,
                                                               service: "User login",
                                                               password: password)
                await MainActor.run(body: {
                    self.user = newUser
                    self.isUserLoggedIn = true
                    self.lastLoginnedUserId = decodedUser.id
                })
            } catch {
                changeLoginButtonState(state: .failure)
                returnToNormalState()
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
