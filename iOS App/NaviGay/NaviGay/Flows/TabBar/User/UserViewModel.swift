//
//  UserViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

final class UserViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Binding var entryRouter: EntryViewRouter
    @Binding var isUserLoggedIn: Bool
    @Binding var user: User?
    
    @Published var userImage: Image = AppImages.logoFull
    
    // MARK: - Private Properties
    
    private let userDataManager: UserDataManagerProtocol
    private let keychinWrapper: KeychainWrapperProtocol
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol,
         keychinWrapper: KeychainWrapperProtocol,
         entryRouter: Binding<EntryViewRouter>,
         isUserLoggedIn: Binding<Bool>,
         user: Binding<User?>) {
        self.userDataManager = userDataManager
        self.keychinWrapper = keychinWrapper
        _entryRouter = entryRouter
        _isUserLoggedIn = isUserLoggedIn
        _user = user
        
    }
}

extension UserViewModel {
    
    // MARK: - Functions
    
    func logOutButtonTapped() {
        withAnimation(.spring()) {
            user = nil
            isUserLoggedIn = false
        }
    }
    
    func loginButtonTapped() {
        withAnimation(.spring()) {
            entryRouter = .loginView
        }
    }
}
