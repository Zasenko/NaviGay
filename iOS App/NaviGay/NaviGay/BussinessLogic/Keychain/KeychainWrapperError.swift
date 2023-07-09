//
//  KeychainWrapperError.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.07.23.
//

import Foundation

//struct KeychainWrapperError: Error {
//
//    // MARK: - Properties
//
//    var message: String?
//    var type: KeychainError
//
//    // MARK: - Inits
//
//    init(status: OSStatus, type: KeychainError) {
//        self.type = type
//        if let errorMessage = SecCopyErrorMessageString(status, nil) {
//            self.message = String(errorMessage)
//        } else {
//            self.message = "Status Code: \(status)"
//        }
//    }
//
//    init(type: KeychainError) {
//        self.type = type
//    }
//
//    init(message: String, type: KeychainError) {
//        self.message = message
//        self.type = type
//    }
//}
