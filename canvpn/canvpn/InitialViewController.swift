//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import NetworkExtension

class InitialViewController: UIViewController {
    
    private var connectionState = ConnectionState.initial {
        didSet {
            setUIState()
        }
    }
    
    private lazy var mainView = MainScreenView()
    
    private var vpnManager: NEVPNManager?
    private var vpnStatus: NEVPNStatus = .invalid

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        setUIState()
        
        vpnManager = NEVPNManager.shared()
        vpnStatus = vpnManager!.connection.status
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        loadPreferences {}
        // loadIP
        // loadServers
        // prepare Ads
        
        
//        onInterstitialUpdate?(AdsConfiguration().interstitialKey)
//        observeStatus()
//        networkVPNUseCase.loadVPNConfig {}
//        loadIP()
//        loadServers()
//        loadRequestAd.value = true
//        prepareAds()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//            self?.updateOnFirstLaunch()
//        }
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    
    private func setUIState() {
        mainView.setStateLabel(text: connectionState.getStateText())
        mainView.setUserInteraction(isEnabled: true)
    }
    
    private func setVPN() {
        switch connectionState {
        case .initial:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        case .connect:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        case .connecting:
            break
        case .connected:
            connectionState = .disconnecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .disconnected
            }
        case .disconnecting:
            break
        case .disconnected:
            connectionState = .connecting
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.connectionState = .connected
            }
        }
    }
    
    private func startConnection() {
        
        
        
    }
    
    private func disconnect() {
        guard let manager = vpnManager else { return }
        manager.connection.stopVPNTunnel()
    }
    
    private func loadPreferences(completion: @escaping () -> Void) {
        guard let manager = vpnManager else { return }
        manager.loadFromPreferences { error in
            assert(error == nil, "Failed to load preferences \(error?.localizedDescription ?? "Unknown Error")")
            completion()
        }
    }
    
    private func saveVPNProtocol(account: String, completion: @escaping () -> Void) {
        guard let manager = vpnManager else { return }
        var neVPNProtocol: NEVPNProtocol
        
        
        let p = NEVPNProtocolIPSec()
        p.username = "vpnserver"
        p.serverAddress = "3.86.250.76"
        p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        
        KeychainWrapper.standard.set("vpnserver", forKey: "SHARED")
        KeychainWrapper.standard.set("vpnserver", forKey: "VPN_PASSWORD")
        
        p.sharedSecretReference = KeychainWrapper.standard.dataRef(forKey: "SHARED")
        p.passwordReference = KeychainWrapper.standard.dataRef(forKey: "VPN_PASSWORD")
        p.useExtendedAuthentication = true
        p.disconnectOnSleep = false
        manager.protocolConfiguration = p
        manager.localizedDescription = "Contensi"
        manager.isEnabled = true
        
        
        manager.saveToPreferences { error in
            if let err = error {
                print("Failed to save Preferences: \(err.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    @objc
    private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        let status = connection.status
        print("NOTIF: status", status.rawValue)
        handleVPNStatus(status)
        
    }
    
    private func handleVPNStatus(_ vpnStatus: NEVPNStatus) {
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
    
    private func loadIP() {
        /* IPAPI entegration
        IPAPI.Service.default.fetch { [weak self] (result, _) in
            guard let self = self else { return }
            
        // TODO: Current IP burda yazılacak
        // self.currentIP.value = result?.ip ?? ""
        }
         */
    }
}

extension InitialViewController: MainScreenViewDelegate {
    func stateViewTapped() {
        startConnection()
    }
}
