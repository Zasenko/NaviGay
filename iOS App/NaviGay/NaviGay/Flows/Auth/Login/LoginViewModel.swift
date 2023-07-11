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
    @Binding var isUserLoggedIn: Bool
    @Binding var lastLoginnedUserId: Int
    @Binding var user: User?
    
    let userDataManager: UserDataManagerProtocol
    let networkManager: AuthNetworkManagerProtocol
    let authManager: AuthManagerProtocol
    let keychinWrapper: KeychainWrapperProtocol
    
    // MARK: - Inits
    
    init(entryRouter: Binding<EntryViewRouter>,
         isUserLoggedIn: Binding<Bool>,
         lastLoginnedUserId: Binding<Int>,
         user: Binding<User?>,
         userDataManager: UserDataManagerProtocol,
         networkManager: AuthNetworkManagerProtocol,
         authManager: AuthManagerProtocol,
         keychinWrapper: KeychainWrapperProtocol) {
        self.userDataManager = userDataManager
        self.networkManager = networkManager
        self.authManager = authManager
        self.keychinWrapper = keychinWrapper
        _entryRouter = entryRouter
        _isUserLoggedIn = isUserLoggedIn
        _lastLoginnedUserId = lastLoginnedUserId
        _user = user
        findlastLoginnedUserEmail()
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
    
    func cleanFields() {
        error = ""
        email = ""
        password = ""
        invalidLoginAttempts = 0
        invalidPasswordAttempts = 0
    }
    
    // MARK: - Private Functions
    
    //ok
    @MainActor
    private func checkEmailPassword() async {
        do {
            try await authManager.checkEmailAndPassword(email: email, password: password)
            try await login()
            loginButtonState = .success
            toTabView()
        } catch AuthManagerErrors.emptyEmail, AuthManagerErrors.wrongEmail {
            self.error = "Incorrect email."
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        } catch AuthManagerErrors.emptyPassword, AuthManagerErrors.noDigit, AuthManagerErrors.noLowercase, AuthManagerErrors.noMinCharacters, AuthManagerErrors.noUppercase {
            self.error = "Wrong password."
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
            //TODO "--- ERROR --- : \(error)"
            self.error = "--- ERROR --- : \(error)"
            changeLoginButtonState(state: .failure)
            returnToNormalState()
        }
    }
    
    //ok
    private func login() async throws {
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
            var user: User? = try await userDataManager.findUser(id: decodedUser.id)
            if let user = user {
                user.updateUser(decodedUser: decodedUser)
            } else {
                user = await userDataManager.createEmptyUser(decodedUser: decodedUser)
            }
            guard let user = user else {
                throw CoreDataManagerError.cantCreateUser
            }
            try await userDataManager.save()
            try keychinWrapper.storeGenericPasswordFor(account: email,
                                                       service: "User login",
                                                       password: password)
            await MainActor.run(body: {
                self.user = user
                self.isUserLoggedIn = true
                self.lastLoginnedUserId = decodedUser.id
            })
        } catch {
            throw error
        }
    }
    
    
    //ok
    private func findlastLoginnedUserEmail() {
        Task {
            if lastLoginnedUserId != 0 {
                
               do {
                    guard let user = try await userDataManager.findUser(id: lastLoginnedUserId),
                          let email = user.email else {
                        return
                    }
                    await MainActor.run(body: {
                        self.email = email
                    })
                } catch {
                    debugPrint("---ERROR--- LoginViewModel findlastLoginnedUserEmail: ", error)
                }
            }
        }
    }
    
    private func changeLoginButtonState(state: LoadState) {
        withAnimation(.spring()) {
            self.loginButtonState = state
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
        self.allViewsDisabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.loginButtonState = .normal
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
