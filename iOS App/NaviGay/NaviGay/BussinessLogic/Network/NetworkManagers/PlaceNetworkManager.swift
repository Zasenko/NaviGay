//
//  PlaceNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import Foundation

protocol PlaceNetworkManagerProtocol {
    func fetchPlace(id: Int) async throws -> PlaceResult

}

final class PlaceNetworkManager {}

//MARK: - PlaceNetworkManagerProtocol
extension PlaceNetworkManager: PlaceNetworkManagerProtocol {
    func fetchPlace(id: Int) async throws -> PlaceResult {
        guard let url = await ApiProperties.shared.getPlaceUrl(id: id) else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(PlaceResult.self, from: data) else {
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
