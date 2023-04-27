//
//  LoginViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import Foundation

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
    
}
