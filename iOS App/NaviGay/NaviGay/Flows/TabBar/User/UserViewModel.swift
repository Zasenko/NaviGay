//
//  UserViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

final class UserViewModel {
    
    // MARK: - Properties
    
    let userDataManager: UserDataManagerProtocol
    
    // MARK: - Inits
    
    init(userDataManager: UserDataManagerProtocol) {
        self.userDataManager = userDataManager
    }
}

extension UserViewModel {
    
    // MARK: - Functions
    
    func logOutButtonTapped() {
        
        Task {
            await userDataManager.deleteUser()
        }
        
    }
}
