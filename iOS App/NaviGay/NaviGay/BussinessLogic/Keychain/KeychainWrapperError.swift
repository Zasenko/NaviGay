//
//  KeychainWrapperError.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.07.23.
//

import Foundation

struct KeychainWrapperError: Error {
    
    enum KeychainErrorType {
        case badData
        case servicesError
        case itemNotFound
        case unableToConvertToString
    }
    
    // MARK: - Properties
    
    var message: String?
    var type: KeychainErrorType
    
    // MARK: - Inits
    
    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        if let errorMessage = SecCopyErrorMessageString(status, nil) {
            self.message = String(errorMessage)
        } else {
            self.message = "Status Code: \(status)"
        }
    }
    
    init(type: KeychainErrorType) {
        self.type = type
    }
    
    init(message: String, type: KeychainErrorType) {
        self.message = message
        self.type = type
    }
}
