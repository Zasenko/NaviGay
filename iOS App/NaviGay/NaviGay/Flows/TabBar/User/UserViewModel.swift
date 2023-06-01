//
//  UserViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

final class UserViewModel {
    
    @Binding var isUserLogin: Bool
    
    init(isUserLogin: Binding<Bool>) {
        self._isUserLogin = isUserLogin
    }
}
