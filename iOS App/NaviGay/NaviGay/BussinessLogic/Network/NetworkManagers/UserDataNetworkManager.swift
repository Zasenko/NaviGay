//
//  UserDataNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 26.06.23.
//

import Foundation

protocol UserDataNetworkManagerProtocol {
    func fetchPlaces(ids: [Int]) async throws -> PlacesResult
}

final class UserDataNetworkManager {}

// MARK: - AuthNetworkManagerProtocol
extension UserDataNetworkManager: UserDataNetworkManagerProtocol {
    
    func fetchPlaces(ids: [Int]) async throws -> PlacesResult {
        
        guard let url = await ApiProperties.shared.getPlacesUrl(ids: ids) else {
            throw NetworkErrors.bedUrl
        }
        print("url ->>>>>>> ", url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(PlacesResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        print("PlacesResult ->>>>>>>> ", decodedResult)
        return decodedResult
    }
}
