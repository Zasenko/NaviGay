//
//  AuthNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation

struct LoginResult: Codable {
    var error: String?
    var user: DecodedUser?
}

enum UserStatus: String, Codable {
    case user, admin, moderator, partner
}

struct DecodedUser: Codable, Identifiable {
    let id: Int
    let name: String
    let bio: String?
    let photo: String?
    let instagram: String?
    let status: UserStatus
    let lastUpdate: String
}

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
            throw NetworkManagerErrors.bedUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedResult
    }
    
}
