//
//  AuthManagerErrors.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 05.05.23.
//

import Foundation

enum AuthManagerErrors: Error {
    case emptyEmail
    case emptyPassword
    case noUppercase
    case noDigit
    case noLowercase
    case noMinCharacters
    case wrongEmail
}
