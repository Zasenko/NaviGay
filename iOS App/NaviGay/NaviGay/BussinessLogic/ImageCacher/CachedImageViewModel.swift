//
//  CachedImageViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

final class CachedImageViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var image: Image? = nil
    let urlString: String?
    
    //MARK: - Initialization
    
    init(url: String?) {
        self.urlString = url
        load()
    }
}

extension CachedImageViewModel {
    
    //MARK: - Functions
    
    func load() {
        Task {
            await self.loadFromCache()
        }
    }
    
    @MainActor
    func loadFromCache() async {
        guard let url = urlString, !url.isEmpty else {
            return
        }
        do {
            self.image = try await ImageLoader.shared.loadImage(urlString: url)
        }
        catch {
            //TODO
            print("CachedImageViewModel - >loadFromCache()", error)
        }
    }
    
}
