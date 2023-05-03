//
//  AuthNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation

protocol AuthNetworkManagerProtocol {
    func login(email: String, password: String) async throws -> LoginResult
}

final class AuthNetworkManager {
    
    //MARK: - Private properties
    
    private let networkMonitor: NetworkMonitor
    private let api: ApiPropertiesProtocol
    
    //MARK: - Inits
    
    init(networkMonitor: NetworkMonitor, api: ApiPropertiesProtocol) {
        self.networkMonitor = networkMonitor
        self.api = api
    }
}

// MARK: - AuthNetworkManagerProtocol
extension AuthNetworkManager: AuthNetworkManagerProtocol {
    func login(email: String, password: String) async throws -> LoginResult {
        guard let url = await api.getLoginUrl(email: email, password: password) else {
            throw NetworkErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        return decodedResult
    }
}
