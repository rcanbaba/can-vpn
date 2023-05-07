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
    
    private var serverList: [Server] = []
    private var selectedServer: Server?
    private var selectedServerCredential: Credential?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: log necessary
        Analytics.logEvent("custom_event_can", parameters: ["deneme" : "134133"])
        
        // to ipsec manager
        //  NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
        // ipSecManager = VPNManager()
        
        networkService = DefaultNetworkService()
        
        setLocationButtonMockData()
        fetchServerList()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: disappear da default a çekebilirsin
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    private func setLocationButtonMockData() {
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
                self.selectedServerCredential = response
                
                guard let manager = self.tunnelManager else { return }
                manager.connectToWg(config: response.configuration)
                
            case .failure(let error):
                self.printDebug("getCredential failure")
                Toaster.showToast(message: "Error occurred, please select location again!")
            }
            
        }
    }
    
    private func fetchServerList() {
        guard let service = networkService else { return }
        let getServerListRequest = GetServerListRequest()
        
        service.request(getServerListRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.printDebug("fetchServerList success")
           //     self.serverList = response.servers.reversed()

                // TODO: set as selected first free server
         //       self.setSelectedServer(server: response.servers.first)
            case .failure(let error):
                Toaster.showToast(message: "Error occurred, please reload again!")
                self.printDebug("fetchServerList failure")
            }
        }
    }
    
    
    
    
}

// MARK: - Set Selected Server
extension MainScreenViewController {
    private func setSelectedServer(server: Server?) {
        selectedServer = server
        selectedServerCredential = nil
        
        DispatchQueue.main.async {
            self.mainView.setLocationFlag(countryCode: server?.location.countryCode.lowercased())
       //     self.mainView.setLocationText(country: server?.location.city, ip: server?.connection.host)
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
        let locationViewController = LocationViewController(serverList: serverList)
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

// MARK: - Print helper for now:
extension MainScreenViewController {
    private func printDebug(_ string: String) {
#if DEBUG
        print("💚: " + string)
#endif
    }
    
}
