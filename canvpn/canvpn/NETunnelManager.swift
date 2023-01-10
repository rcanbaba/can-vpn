//
//  NETunnelManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.01.2023.
//

import NetworkExtension

protocol NETunnelManagerDelegate: AnyObject {
    func statusChanged(state: ConnectionState)
}


class NETunnelManager {
    
    private var manager: NETunnelProviderManager?
    private var status: NEVPNStatus = .invalid
    
    public weak var delegate: NETunnelManagerDelegate?
    
    
    init() {
        createManager()
       // status = manager!.connection.status
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        let status = connection.status
        print("NOTIF: NETunnel: status", status.rawValue)
        handleVPNStatus(status)
    }
    
    private func handleVPNStatus(_ vpnStatus: NEVPNStatus) {
        switch vpnStatus {
        case .invalid:
            delegate?.statusChanged(state: .initial)
        case .disconnected:
            //TODO: bu delayları view tarafına taşıyabliriz !!!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.delegate?.statusChanged(state: .disconnected)
            }
        case .connecting:
            delegate?.statusChanged(state: .connecting)
        case .connected:
            //TODO: bu delayları view tarafına taşıyabliriz !!!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.delegate?.statusChanged(state: .connected)
            }
        case .reasserting:
            delegate?.statusChanged(state: .connecting)
        case .disconnecting:
            delegate?.statusChanged(state: .disconnecting)
        @unknown default:
            break
        }
        // TODO:
       // loadIP()
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
            // If the VPN is connected, disconnect.
            disconnect()
        case .disconnected, .invalid:
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
            delegate?.statusChanged(state: .initial)
            debugPrint("Failed to start tunnel (configuration invalid)")
            return
        } catch NEVPNError.configurationDisabled {
            delegate?.statusChanged(state: .initial)
            debugPrint("Failed to start tunnel (configuration disabled)")
            return
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            delegate?.statusChanged(state: .initial)
            return
        }

    }
    
    private func disconnect() {
        guard let manager = manager else { return }
        manager.connection.stopVPNTunnel()
        delegate?.statusChanged(state: .disconnected)
    }
    
    
// MARK: Public Methods
    public func changeVPNState() {
        Task {
            await toggleVPN()
        }
    }
    
}
