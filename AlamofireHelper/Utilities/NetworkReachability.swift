//
//  NetworkReachability.swift
//  AlamofireHelper
//
//  Created by Prakhar Jaiswal on 21/01/26.
//


import Foundation
import Network

// MARK: - Network Reachability Manager

class NetworkReachability {
    
    static let shared = NetworkReachability()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkReachability")
    
    private(set) var isConnected: Bool = true
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // Callback for network status changes
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {
        startMonitoring()
    }
    
    // MARK: - Start Monitoring
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            self.isConnected = path.status == .satisfied
            
            // Determine connection type
            if path.usesInterfaceType(.wifi) {
                self.connectionType = .wifi
            } else if path.usesInterfaceType(.cellular) {
                self.connectionType = .cellular
            } else if path.usesInterfaceType(.wiredEthernet) {
                self.connectionType = .ethernet
            } else {
                self.connectionType = .unknown
            }
            
            // Notify on main thread
            DispatchQueue.main.async {
                self.onStatusChange?(self.isConnected)
            }
        }
        
        monitor.start(queue: queue)
    }
    
    // MARK: - Stop Monitoring
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    // MARK: - Get Connection Status
    
    func checkConnection() -> Bool {
        return isConnected
    }
    
    func getConnectionType() -> String {
        switch connectionType {
        case .wifi:
            return "WiFi"
        case .cellular:
            return "Cellular"
        case .ethernet:
            return "Ethernet"
        case .unknown:
            return "Unknown"
        }
    }
}