//
//  EventNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 26.05.23.
//

import Foundation

protocol EventNetworkManagerProtocol {
    func fetchEvent(id: Int) async throws -> EventResult
}

final class EventNetworkManager {}

//MARK: - EventNetworkManagerProtocol
extension EventNetworkManager: EventNetworkManagerProtocol {
    
    func fetchEvent(id: Int) async throws -> EventResult {
        guard let url = await ApiProperties.shared.getEventUrl(id: id) else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(EventResult.self, from: data) else {
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

