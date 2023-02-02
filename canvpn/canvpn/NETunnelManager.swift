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
    func stateChanged(state: TunnelState)
}

class NETunnelManager {
    
    private var manager: NETunnelProviderManager?
    private var status: NEVPNStatus = .invalid
    
    public weak var delegate: NETunnelManagerDelegate?
    
    
    init() {
        createManager()
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        let status = connection.status
        handleVPNStatus(status)
    }
    
    private func handleVPNStatus(_ vpnStatus: NEVPNStatus) {
        switch vpnStatus {
        case .invalid:
            print("NOTIF: NETunnel: initial")
        case .disconnected:
            print("NOTIF: NETunnel: disconnected")
        case .connecting, .reasserting:
            print("NOTIF: NETunnel: connecting")
        case .connected:
            print("NOTIF: NETunnel: connected")
        case .disconnecting:
            print("NOTIF: NETunnel: disconnecting")
        @unknown default:
            break
        }
    }
    
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
                return managers[0]
            }
            
            return NETunnelProviderManager()
        } catch {
            return NETunnelProviderManager()
        }
    }
    
    // Toggle VPN
    private func toggleVPN() async {
        manager = await getManagerWithPreferences()
        
        switch manager?.connection.status {
        case .connected:
            delegate?.stateChanged(state: .disconnecting)
            disconnect()
        case .disconnected, .invalid:
            delegate?.stateChanged(state: .connecting)
            await saveAndConnect()
            
        default:
            break
        }
        
    }
    
    private func saveAndConnect() async {
        guard let manager = manager else { return }
        
        let configuration = NETunnelProviderProtocol()
        configuration.providerBundleIdentifier = "com.arbtech.canvpn.sonDenemeVpn.PacketTunnel"
        configuration.serverAddress = SERVER_ENDPOINT_STRING
        configuration.providerConfiguration = [:]
        
        // Set the manager's configuration and mark it as enabled.
        manager.protocolConfiguration = configuration
        manager.localizedDescription = "canVPNWired"
        manager.isEnabled = true
        
        do {
            // Attempt to save the new manager to preferences.
            try await manager.saveToPreferences()
        } catch {
            print("Error saving preferences:", error)
            return
        }
        
        do {
            // Now, load the manager from preferences.
            let loadedManagers = try await NETunnelProviderManager.loadAllFromPreferences()
            
            // Start the VPN.
            try loadedManagers[0].connection.startVPNTunnel()
            
            print("Started tunnel successfully.")
        }  catch NEVPNError.configurationInvalid {
            delegate?.stateChanged(state: .failed)
            debugPrint("Failed to start tunnel (configuration invalid)")
            return
        } catch NEVPNError.configurationDisabled {
            delegate?.stateChanged(state: .failed)
            debugPrint("Failed to start tunnel (configuration disabled)")
            return
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            delegate?.stateChanged(state: .failed)
            return
        }

    }
    
    private func disconnect() {
        guard let manager = manager else { return }
        manager.connection.stopVPNTunnel()
    }
    
    
// MARK: Public Methods
    public func changeVPNState() {
        Task {
            await toggleVPN()
        }
    }
    
}
