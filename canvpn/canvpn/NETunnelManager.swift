//
//  NETunnelManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import NetworkExtension

enum TunnelState: Int {
    case connecting = 0
    case disconnecting = 1
    case failed = 2
}

protocol NETunnelManagerDelegate: AnyObject {
    func stateChanged(state: NEVPNStatus)
}

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
    
    private func saveAndConnect() async {
        guard let manager = manager else {
            delegate?.stateChanged(state: .invalid)
            return
        }
        
        let configuration = NETunnelProviderProtocol()
        configuration.providerBundleIdentifier = "com.arbtech.canvpn.sonDenemeVpn.PacketTunnel"
        configuration.serverAddress = SERVER_ENDPOINT_STRING
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
            try manager.connection.startVPNTunnel()
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
    
    private func connectToWireguard() async {
        manager = await getManagerWithPreferences()
        await saveAndConnect()
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
    
    public func connectToWg() {
        delegate?.stateChanged(state: .connecting)
        Task {
            await connectToWireguard()
        }
    }
    
    public func disconnectFromWg() {
        delegate?.stateChanged(state: .disconnecting)
        Task {
            await disconnectFromWireguard()
        }
    }
    
}
