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
    
    // TO ipsec manager
    //    @objc private func statusDidChange(_ notification: Notification) {
    //        guard let connection = notification.object as? NEVPNConnection else { return }
    //        vpnStatus = connection.status
    //        setManagerStateUI()
    //    }
    
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
            
            guard let manager = self.tunnelManager else { return }
            manager.connectToWg()
            
            switch result {
            case .success(let response):
                self.printDebug("getCredential success")
                self.selectedServerCredential = response
                
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
                self.serverList = response.servers
                
                /* MOCK LIST
                 
                 let mockConnection1 = Connection(host: "230.24.12.16", port: "443")
                 let mockLocation1 = Location(countryCode: "IT", city: "Italy")
                 let mock1 = Server(id: "1", type: 0, engine: 1, connection: mockConnection1, location: mockLocation1)
                 
                 let mockConnection2 = Connection(host: "110.95.90.16", port: "443")
                 let mockLocation2 = Location(countryCode: "SG", city: "Singapore")
                 let mock2 = Server(id: "1", type: 0, engine: 1, connection: mockConnection2, location: mockLocation2)
                 
                 let mockConnection6 = Connection(host: "110.96.95.16", port: "443")
                 let mockLocation6 = Location(countryCode: "US", city: "Virginia - 2")
                 let mock6 = Server(id: "1", type: 0, engine: 1, connection: mockConnection6, location: mockLocation6)
                 
                 let mockConnection3 = Connection(host: "103.42.29.0", port: "443")
                 let mockLocation3 = Location(countryCode: "DE", city: "Germany")
                 let mock3 = Server(id: "1", type: 0, engine: 1, connection: mockConnection3, location: mockLocation3)
                 
                 let mockConnection4 = Connection(host: "105.16.176.0", port: "443")
                 let mockLocation4 = Location(countryCode: "FR", city: "France")
                 let mock4 = Server(id: "1", type: 0, engine: 1, connection: mockConnection4, location: mockLocation4)
                 
                 let mockConnection5 = Connection(host: "101.167.184.0", port: "443")
                 let mockLocation5 = Location(countryCode: "GB", city: "London")
                 let mock5 = Server(id: "1", type: 0, engine: 1, connection: mockConnection5, location: mockLocation5)
                 
                 self.serverList.append(mock1)
                 self.serverList.append(mock2)
                 self.serverList.append(mock3)
                 self.serverList.append(mock4)
                 self.serverList.append(mock5)
                 self.serverList.append(mock6)
                 
                 */
                
                // TODO: set as selected first free server
                self.setSelectedServer(server: response.servers.first)
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
            self.mainView.setLocationText(country: server?.location.city, ip: server?.connection.host)
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
                    // self.setUI(state: .connecting)
                }
                getCredential(serverId: selectedServer.id)
                
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
