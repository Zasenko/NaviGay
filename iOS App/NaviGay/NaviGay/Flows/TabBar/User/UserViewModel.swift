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
    @Binding var isUserLogin: Bool
    
    @Published var userImage: Image = AppImages.logoFull
    
    let userDataManager: UserDataManagerProtocol
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol, entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>) {
        self.userDataManager = userDataManager
        _entryRouter = entryRouter
        _isUserLogin = isUserLogin
    }
}

extension UserViewModel {
    
    // MARK: - Functions
    
    func logOutButtonTapped() {
        userDataManager.deleteUser { [weak self] result in
            if result {
                withAnimation(.spring()) {
                    self?.isUserLogin = false
                }
            }
        }
        
    }
    
    func loginButtonTapped() {
        withAnimation(.spring()) {
            entryRouter = .loginView
        }
    }
}
