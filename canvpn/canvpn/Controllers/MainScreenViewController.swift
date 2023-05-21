//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import NetworkExtension
import Lottie
import FirebaseAnalytics

class MainScreenViewController: UIViewController {
    
    private lazy var mainView = MainScreenView()
    
    private var tunnelManager: NETunnelManager?
    //  private var ipSecManager: VPNManager?
    
    private var vpnStatus: NEVPNStatus = .invalid
    
    private var networkService: DefaultNetworkService?
    
    private var selectedServer: Server?
    private var selectedServerConfig: Configuration?
    
    //TODO: alttan yukarı gelince ne oluyor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("custom_event_can", parameters: ["deneme" : "134133"])
        
        // to ipsec manager
        //  NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
        // ipSecManager = VPNManager()
        
        networkService = DefaultNetworkService()
        
        setLocationButtonMockData()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: disappear da default a çekebilirsin
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    @objc private func willEnterForegroundNotification(_ sender: Notification) {
        guard let manager = tunnelManager,let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "Error occurred, please reload app.")
            return }

        if currentManagerState == .connected {
            setState(state: .connected)
        } else if currentManagerState == .connecting {
            setState(state: .connecting)
        } else if currentManagerState == .disconnecting {
            setState(state: .disconnecting)
        } else {
            setState(state: .disconnected)
        }
        
    }
    
    private func setLocationButtonMockData() {
        
        // TODO: config listesinden sinyali en iyi free yi set
        
        mainView.setLocationSignal(level: SignalLevel.good)
        mainView.setLocationFlag(countryCode: "de")
        mainView.setLocationText(country: "Germany", ip: "79.110.53.92")
    }
    
    private func configureUI() {
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setMainUI(state: ConnectionState) {
        DispatchQueue.main.async {
            self.mainView.setState(state: state)
        }
    }
    
    private func setState(state: NEVPNStatus) {
        vpnStatus = state
        switch state {
        case .invalid:
            setMainUI(state: .disconnected)
        case .disconnected:
            setMainUI(state: .disconnected)
        case .connecting:
            setMainUI(state: .connecting)
        case .connected:
            setMainUI(state: .connected)
        case .reasserting:
            setMainUI(state: .connecting)
        case .disconnecting:
            setMainUI(state: .disconnecting)
        @unknown default:
            printDebug("unknown vpnStatus")
            break
        }
    }
    
}

// MARK: - API Calls
extension MainScreenViewController {
    
    private func getCredential(serverId: String) {
        guard let service = networkService else { return }
        var getCredentialRequest = GetCredentialRequest()
        getCredentialRequest.setParams(serverId: serverId)
        
        service.request(getCredentialRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.printDebug("getCredential success")
                self.selectedServerConfig = response
                
                guard let manager = self.tunnelManager else { return }
                manager.connectToWg(config: response)
                
            case .failure(let error):
                self.printDebug("getCredential failure")
                Toaster.showToast(message: "Error occurred, please select location again!")
            }
            
        }
    }

    
}

// MARK: - Set Selected Server
extension MainScreenViewController {
    private func setSelectedServer(server: Server?) {
        selectedServer = server
        selectedServerConfig = nil
        
        DispatchQueue.main.async {
            self.mainView.setLocationFlag(countryCode: server?.location.countryCode.lowercased())
            self.mainView.setLocationText(country: server?.location.city, ip: server?.url)
            // TODO: set from given data
            self.mainView.setLocationSignal(level: .good)
        }
    }
    
}

// MARK: - VPN manager interactions
extension MainScreenViewController: MainScreenViewDelegate {
    func goProButtonTapped() {
        let goProViewController = GoPremiumViewController()
        goProViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(goProViewController, animated: true)
    }
    
    func locationButtonTapped() {
        let locationViewController = LocationViewController()
        locationViewController.hidesBottomBarWhenPushed = true
        locationViewController.delegate = self
        self.navigationController?.pushViewController(locationViewController, animated: true)
    }
    
    func changeStateTapped() {
        guard let manager = tunnelManager, let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "Error occurred, please reload app.")
            return }
        
        if currentManagerState == .disconnected {
            // TO CONNECT
            if let selectedServer = selectedServer {
                DispatchQueue.main.async {
                    self.setMainUI(state: .connecting)
                    self.getCredential(serverId: selectedServer.id)
                }
            } else {
                Toaster.showToast(message: "Error occurred, please select a location before.")
            }
        } else if currentManagerState == .connected {
            //    setManagerStateUI()
            manager.disconnectFromWg()
        } else {
            Toaster.showToast(message: "Error occurred, please try again.")
        }
        
        
        
    }
}


// MARK: - NETunnelManagerDelegate
extension MainScreenViewController: NETunnelManagerDelegate {
    func stateChanged(state: NEVPNStatus) {
        setState(state: state)
    }
}

// MARK: - LocationViewControllerDelegate
extension MainScreenViewController: LocationViewControllerDelegate {
    func selectedServer(server: Server) {
        setSelectedServer(server: server)
        // TODO: If selected premium, show premium controller - flow
    }
    
}
