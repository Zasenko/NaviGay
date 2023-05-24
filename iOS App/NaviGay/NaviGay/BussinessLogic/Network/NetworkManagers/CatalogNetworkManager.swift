//
//  CatalogNetworkManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import Foundation

protocol CatalogNetworkManagerProtocol {
    func fetchCountries() async throws -> CountriesResult
    func fetchCountry(countryId: Int) async throws -> CountryResult
    func fetchCity(id: Int) async throws -> CityResult
}

final class CatalogNetworkManager {
}

// MARK: - CatalogNetworkManagerProtocol

extension CatalogNetworkManager: CatalogNetworkManagerProtocol {
    
    func fetchCountries() async throws -> CountriesResult {
        guard let url = await ApiProperties.shared.getCountriesUrl() else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(CountriesResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        if let resultError = decodedResult.error {
            
            //TODO
            
            print(resultError)
            throw NetworkErrors.apiError
        }
        return decodedResult
    }
    
    func fetchCountry(countryId: Int) async throws -> CountryResult {
        guard let url = await ApiProperties.shared.getCountryUrl(countryId: countryId) else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(CountryResult.self, from: data) else {
            throw NetworkErrors.decoderError
        }
        if let resultError = decodedResult.error {
            
            //TODO
            
            print(resultError)
            throw NetworkErrors.apiError
        }
        return decodedResult
    }
    
    func fetchCity(id: Int) async throws -> CityResult {
        guard let url = await ApiProperties.shared.getCityUrl(id: id) else {
            throw NetworkErrors.bedUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
                
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.invalidData
        }
        guard let decodedResult = try? JSONDecoder().decode(CityResult.self, from: data) else {
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
