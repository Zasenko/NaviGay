//
//  AuthManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 02.05.23.
//

import Foundation

protocol AuthManagerProtocol {
    func checkEmailPassword(email: String, password: String, complition: @escaping((Result<Bool, AuthManagerErrors>) -> Void))
}

final class AuthManager {}

extension AuthManager: AuthManagerProtocol {
    func checkEmailPassword(email: String, password: String, complition: @escaping((Result<Bool, AuthManagerErrors>) -> Void)) {
        DispatchQueue.global().async {
            if email.isEmpty {
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.emptyEmail))
                }
                return
            }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailPred.evaluate(with: email) {
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.wrongEmail))
                }
                return
            }
            if password.isEmpty {
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.emptyPassword))
                }
                return
            }
            if password.count < 8 {
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.noMinCharacters))
                }
                return
            }
            if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)){
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.noDigit))
                }
                return
            }
            if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)){
                DispatchQueue.main.async {
                    complition(.failure(AuthManagerErrors.noLowercase))
                }
                return
            }
            DispatchQueue.main.async {
                complition(.success(true))
            }
        }
    }
}
