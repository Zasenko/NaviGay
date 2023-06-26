//
//  AroundNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.06.23.
//

import Foundation

protocol AroundNetworkManagerProtocol {
    func fetchLocationsAround(latitude: Double, longitude: Double) async throws -> LocationsAroundResult
}

final class AroundNetworkManager {}

//MARK: - EventNetworkManagerProtocol
extension AroundNetworkManager: AroundNetworkManagerProtocol {
    
    func fetchLocationsAround(latitude: Double, longitude: Double) async throws -> LocationsAroundResult {
        guard let url = await ApiProperties.shared.getLocationAroundMeUrl(latitude: latitude, longitude: longitude) else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(LocationsAroundResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        if let resultError = decodedResult.error {
            
            //TODO
            
            print(resultError)
            throw NetworkErrors.apiError
        }
        return decodedResult
    }
}

