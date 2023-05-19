//
//  CachedImageViewModel.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI

final class CachedImageViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var image: Image = AppImages.appIcon
    
    let url: String?
    let width: CGFloat
    let height: CGFloat
    
    //MARK: - Initialization
    
    init(url: String?, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
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
        guard let url = url else { return }
        do {
            self.image = try await ImageLoader.shared.loadImage(urlString: url)
        }
        catch {
            
            //TODO
            
            print(error.localizedDescription)
        }
    }
    
}
