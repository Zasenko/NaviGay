//
//  ImageCache.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import Foundation

final class ImageCache {
    
    typealias CacheType = NSCache<NSString, NSData>
    
    //MARK: - Properties
    
    static let shared = ImageCache()
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Private properties
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 5242800 Bytes > 50MB
        return cache
    }()
}

extension ImageCache {

    //MARK: - Functions
    
    func object(forKey key: NSString) -> Data? {
        return cache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
