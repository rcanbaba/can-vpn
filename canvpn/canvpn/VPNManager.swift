//
//  VPNManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 26.12.2022.
//

import NetworkExtension

protocol VPNManagerDelegate: AnyObject {
    func statusChanged(state: ConnectionState)
}


class VPNManager {
    
    private var manager: NEVPNManager?
    private var status: NEVPNStatus = .invalid
    
    public weak var delegate: VPNManagerDelegate?
    
    
    init() {
        manager = NEVPNManager.shared()
        loadPreferences {}
        status = manager!.connection.status
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        let status = connection.status
        print("NOTIF: NEVPN: status", status.rawValue)
        
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
        
        switch vpnStatus {
        case .invalid:
            print("NOTIF: invalid")
        case .disconnected:
            print("NOTIF: disconnected")
        case .connecting:
            print("NOTIF: connecting")
        case .connected:
            print("NOTIF: connected")
        case .reasserting:
            print("NOTIF: reasserting")
        case .disconnecting:
            print("NOTIF: disconnecting")
        @unknown default:
            break
        }
        // TODO:
       // loadIP()
    }
    
    
    private func loadPreferences(completion: @escaping () -> Void) {
        guard let manager = manager else { return }
        //TODO: weak reference
        manager.loadFromPreferences { error in
            assert(error == nil, "Failed to load preferences \(error?.localizedDescription ?? "Unknown Error")")
            self.delegate?.statusChanged(state: .initial)
            completion()
        }
    }
    
    func save(config: VpnServerItem, completion: @escaping () -> Void) {
        //  config.saveToDefaults()
        //   config.saveToDefaults()
        loadPreferences { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.saveVPNProtocol(account: config, completion: completion)
        }
    }
    
    private func saveAndConnect(to: VpnServerItem) {
        save(config: to) { [weak self] in
            _ = self?.connectVPN()
        }
    }
    
    private func saveVPNProtocol(account: VpnServerItem, completion: @escaping () -> Void) {
        guard let manager = manager else { return }

        let IPSecProtocol = NEVPNProtocolIPSec()
        IPSecProtocol.username = account.username
        IPSecProtocol.serverAddress = account.ip
        IPSecProtocol.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        
        KeychainWrapper.standard.set(account.secret, forKey: "SHARED")
        KeychainWrapper.standard.set(account.password, forKey: "VPN_PASSWORD")
        
        IPSecProtocol.sharedSecretReference = KeychainWrapper.standard.dataRef(forKey: "SHARED")
        IPSecProtocol.passwordReference = KeychainWrapper.standard.dataRef(forKey: "VPN_PASSWORD")
        IPSecProtocol.useExtendedAuthentication = true
        IPSecProtocol.disconnectOnSleep = false
        manager.protocolConfiguration = IPSecProtocol
        manager.localizedDescription = Constants.vpnListingName
        manager.isEnabled = true
        
        
        manager.saveToPreferences { error in
            if let err = error {
                print("Failed to save Preferences: \(err.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    private func connectVPN() -> Bool {
        guard let manager = manager else { return false }
        debugPrint("!!!!! Establishing Connection !!!!!")
        do {
            try manager.connection.startVPNTunnel()
            delegate?.statusChanged(state: .connecting)
            return true
        } catch NEVPNError.configurationInvalid {
            delegate?.statusChanged(state: .initial)
            debugPrint("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            delegate?.statusChanged(state: .initial)
            debugPrint("Failed to start tunnel (configuration disabled)")
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            delegate?.statusChanged(state: .initial)
            return false
        }
        delegate?.statusChanged(state: .initial)
        return false
    }
    
    
    private func disconnect() {
        guard let manager = manager else { return }
        manager.connection.stopVPNTunnel()
        delegate?.statusChanged(state: .disconnected)
    }
    
// MARK: Public Methods
    public func changeVPNState(currentState: ConnectionState, selectedVPN: VpnServerItem) {
        switch currentState {
        case .initial:
            saveAndConnect(to: selectedVPN)
        case .connecting, .disconnecting:
            print("STATE NOT CHANGED")
        case .connected:
            disconnect()
        case .disconnected:
            saveAndConnect(to: selectedVPN)
        }
    }
    
}
