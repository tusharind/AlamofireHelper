//
//  NetworkReachability.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Foundation
import Network

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

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            isConnected = path.status == .satisfied

            // Determine connection type
            if path.usesInterfaceType(.wifi) {
                connectionType = .wifi
            } else if path.usesInterfaceType(.cellular) {
                connectionType = .cellular
            } else if path.usesInterfaceType(.wiredEthernet) {
                connectionType = .ethernet
            } else {
                connectionType = .unknown
            }

            // Notify on main thread
            DispatchQueue.main.async {
                self.onStatusChange?(self.isConnected)
            }
        }

        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    func checkConnection() -> Bool {
        isConnected
    }

    func getConnectionType() -> String {
        switch connectionType {
        case .wifi:
            "WiFi"
        case .cellular:
            "Cellular"
        case .ethernet:
            "Ethernet"
        case .unknown:
            "Unknown"
        }
    }
}
