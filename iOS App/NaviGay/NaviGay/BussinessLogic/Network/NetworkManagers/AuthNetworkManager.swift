//
//  AuthNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation

protocol AuthNetworkManagerProtocol {
    func login(email: String, password: String) async throws -> LoginResult
    func registration(email: String, password: String) async throws -> LoginResult
}

final class AuthNetworkManager {
    
    //MARK: - Private properties
    
    //MARK: - Inits
}

// MARK: - AuthNetworkManagerProtocol
extension AuthNetworkManager: AuthNetworkManagerProtocol {
    
    func login(email: String, password: String) async throws -> LoginResult {
        guard let url = await ApiProperties.shared.getLoginUrl() else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
      //  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      //  request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = parameters.percentEncoded()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        return decodedResult
    }
    
    func registration(email: String, password: String) async throws -> LoginResult {
        guard let url = await ApiProperties.shared.getrRegistrationUrl() else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = parameters.percentEncoded()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        return decodedResult
    }
}
