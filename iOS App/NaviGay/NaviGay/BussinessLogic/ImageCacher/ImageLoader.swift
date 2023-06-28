//
//  ImageLoader.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

enum RetriverError: Error {
    case invalidUrl
    case invalidData
    case invalidCacheData
}

final class ImageLoader {
    
    //MARK: - Properties
    
    static let shared = ImageLoader()
    
    //MARK: - Private Properties
    
    private let cache: ImageCache = .shared
    
    //MARK: - Initialization
    
    private init() {}
}

extension ImageLoader {
    
    //MARK: - Functions
    
    func loadImage(urlString: String) async throws -> Image? {
        if let imageData = cache.object(forKey: urlString) {
            return try await makeImageFromData(data: imageData)
        }
        
        do {
            let data = try await fetch(stringUrl: urlString)
            cache.set(object: data, forKey: urlString)
            return try await makeImageFromData(data: data)
        } catch {
            return nil
        }
    }
    
    //MARK: - Private functions
    
    private func makeImageFromData(data: Data) async throws -> Image {
        guard let uiImage = UIImage(data: data) else {
            throw RetriverError.invalidData
        }
        return Image(uiImage: uiImage)
    }
    
    private func fetch(stringUrl: String) async throws -> Data {
        guard let url = URL(string: stringUrl) else {
            throw RetriverError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func loadDataFromCache(for key: String) async throws -> Data {
        guard let imageData = cache.object(forKey: key) else {
            throw RetriverError.invalidCacheData
        }
        return imageData
    }
}
