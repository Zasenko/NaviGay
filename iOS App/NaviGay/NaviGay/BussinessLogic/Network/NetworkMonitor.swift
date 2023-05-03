//
//  NetworkMonitor.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    // MARK: - Properties
    
    var isInternetConnected = false
    
    // MARK: - Private Properties
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    
    // MARK: - Inits
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isInternetConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
