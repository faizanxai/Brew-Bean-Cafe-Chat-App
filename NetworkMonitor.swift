//
//  NetworkMonitor.swift
//  BrewBeanChatApp
//
//  Created by Faizan Nabi on 26/11/2026.
//


import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?.isConnected = path.status == .satisfied
            }
        
        }
        monitor.start(queue: queue)
    }
}
