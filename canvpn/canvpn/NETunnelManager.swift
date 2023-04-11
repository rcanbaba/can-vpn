//
//  NETunnelManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import NetworkExtension
import WireGuardKit

enum TunnelState: Int {
    case connecting = 0
    case disconnecting = 1
    case failed = 2
}

protocol NETunnelManagerDelegate: AnyObject {
    func stateChanged(state: NEVPNStatus)
}

var tunnelConfiguration123456: TunnelConfiguration?

class NETunnelManager {
    
    private var manager: NETunnelProviderManager?
    
    public weak var delegate: NETunnelManagerDelegate?
    
    init() {
        createManager()
    }
    
    deinit { }
    
    /// getManagerWithPreferences if there is no manager before created, create new one
    ///
    private func createManager() {
        Task {
            manager = await getManagerWithPreferences()
        }
    }
    
    /// Returns either an existing `NETunnelProviderManager` or a newly
    /// constructed one if the VPN configuration has not been previously saved.
    ///
    /// - Returns: The `NETunnelProviderManager`.
    private func getManagerWithPreferences() async -> NETunnelProviderManager {
        do {
            let managers = try await NETunnelProviderManager.loadAllFromPreferences()
            
            if managers.count > 0 {
                delegate?.stateChanged(state: managers[0].connection.status)
                return managers[0]
            }
            delegate?.stateChanged(state: .invalid)
            return NETunnelProviderManager()
        } catch {
            delegate?.stateChanged(state: .invalid)
            return NETunnelProviderManager()
        }
    }
    
    private func saveAndConnect(config: Configuration?) async {
        guard let manager = manager else {
            delegate?.stateChanged(state: .invalid)
            return
        }
//        
        let configuration = NETunnelProviderProtocol()
        configuration.providerBundleIdentifier = "com.arbtech.ilovevpn.PacketTunnel"
        configuration.serverAddress = SERVER_ENDPOINT_STRING_5
        configuration.providerConfiguration = [:]
        
        // Set the manager's configuration and mark it as enabled.
        manager.protocolConfiguration = configuration
        manager.localizedDescription = "iLoveVPN"
        manager.isEnabled = true
        
        do {
            // Attempt to save the new manager to preferences.
            try await manager.saveToPreferences()
        } catch {
            delegate?.stateChanged(state: .invalid)
            print("Error saving preferences:", error)
            return
        }
        
        do {
            // Now, load the manager from preferences.
            try await manager.loadFromPreferences()
            
            // Start the VPN.
            try manager.connection.startVPNTunnel(options: ["can": NSString("15.237.93.242:57630")])
            print("Started tunnel successfully.")
            delegate?.stateChanged(state: .connected)
        }  catch NEVPNError.configurationInvalid {
            delegate?.stateChanged(state: .invalid)
            debugPrint("Failed to start tunnel (configuration invalid)")
            return
        } catch NEVPNError.configurationDisabled {
            delegate?.stateChanged(state: .invalid)
            debugPrint("Failed to start tunnel (configuration disabled)")
            return
        } catch let error as NSError {
            delegate?.stateChanged(state: .invalid)
            debugPrint(error.localizedDescription)
            return
        }

    }
    
    private func disconnect() {
        guard let manager = manager else { return }
        manager.connection.stopVPNTunnel()
        delegate?.stateChanged(state: .disconnected)
    }
    
    private func connectToWireguard(config: Configuration?) async {
        manager = await getManagerWithPreferences()
        await saveAndConnect(config: config)
    }
    
    private func disconnectFromWireguard() async {
        manager = await getManagerWithPreferences()
        disconnect()
    }
    
}

// MARK: Public Methods
extension NETunnelManager {
    public func getManagerState() -> ConnectionState? {
        guard let manager = manager else { return nil }
        
        switch manager.connection.status {
        case .connected:
            return .connected
        case .disconnected, .invalid:
            return .disconnected
        default:
            return nil
        }
    }
    
    public func connectToWg(config: Configuration?) {
        delegate?.stateChanged(state: .connecting)
        Task {
            await connectToWireguard(config: config)
        }
    }
    
    public func disconnectFromWg() {
        delegate?.stateChanged(state: .disconnecting)
        Task {
            await disconnectFromWireguard()
        }
    }
    
}


extension TunnelConfiguration {
    
    func asWgQuickConfig() -> String {
        var output = "[Interface]\n"
        output.append("PrivateKey = \(interface.privateKey.base64Key)\n")
        if let listenPort = interface.listenPort {
            output.append("ListenPort = \(listenPort)\n")
        }
        if !interface.addresses.isEmpty {
            let addressString = interface.addresses.map { $0.stringRepresentation }.joined(separator: ", ")
            output.append("Address = \(addressString)\n")
        }
        if !interface.dns.isEmpty || !interface.dnsSearch.isEmpty {
            var dnsLine = interface.dns.map { $0.stringRepresentation }
            dnsLine.append(contentsOf: interface.dnsSearch)
            let dnsString = dnsLine.joined(separator: ", ")
            output.append("DNS = \(dnsString)\n")
        }
        if let mtu = interface.mtu {
            output.append("MTU = \(mtu)\n")
        }

        for peer in peers {
            output.append("\n[Peer]\n")
            output.append("PublicKey = \(peer.publicKey.base64Key)\n")
            if let preSharedKey = peer.preSharedKey?.base64Key {
                output.append("PresharedKey = \(preSharedKey)\n")
            }
            if !peer.allowedIPs.isEmpty {
                let allowedIPsString = peer.allowedIPs.map { $0.stringRepresentation }.joined(separator: ", ")
                output.append("AllowedIPs = \(allowedIPsString)\n")
            }
            if let endpoint = peer.endpoint {
                output.append("Endpoint = \(endpoint.stringRepresentation)\n")
            }
            if let persistentKeepAlive = peer.persistentKeepAlive {
                output.append("PersistentKeepalive = \(persistentKeepAlive)\n")
            }
        }

        return output
    }
    
    
}


extension NETunnelProviderProtocol {
    convenience init?(tunnelConfiguration: TunnelConfiguration, previouslyFrom old: NEVPNProtocol? = nil) {
        self.init()
        
        guard let appId = Bundle.main.bundleIdentifier else { return nil }
        providerBundleIdentifier = "\(appId).network-extension"
        
#if os(macOS)
        providerConfiguration = ["UID": getuid()]
#endif
        
        let endpoints = tunnelConfiguration.peers.compactMap { $0.endpoint }
        if endpoints.count == 1 {
            serverAddress = endpoints[0].stringRepresentation
        } else if endpoints.isEmpty {
            serverAddress = "Unspecified"
        } else {
            serverAddress = "Multiple endpoints"
        }
    }
    
    
    static func asTunnelConfiguration() -> TunnelConfiguration? {
        
        guard let conf = tunnelConfiguration123456 else { return nil }
        
        return conf
    }
}
