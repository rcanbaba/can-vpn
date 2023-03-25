//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import NetworkExtension
import CommonCrypto
import Lottie
import FirebaseAnalytics

class MainScreenViewController: UIViewController {
    
    private lazy var mainView = MainScreenView()
    
    private var vpnStatus: NEVPNStatus = .invalid
    private var tunnelState: TunnelState = .failed
    private var tunnelManager: NETunnelManager?
    private var ipSecManager: VPNManager?
    private var networkService: DefaultNetworkService?
    
    private var serverList: [Server] = []
    
    var boolInitialSet: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("custom_event_can", parameters: ["deneme" : "134133"])
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
       // ipSecManager = VPNManager()
        
        networkService = DefaultNetworkService()
        fetchServerList()
        configureUI()
        
        setLocationButtonMockData()
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
    
    @objc private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        vpnStatus = connection.status
        setManagerStateUI()
    }
    
    private func setUI(state: ConnectionState) {
        DispatchQueue.main.async {
            self.mainView.setState(state: state)
        }
    }
    
    func fetchServerList() {
        guard let service = networkService else { return }
        let searchRequest = SearchCompanyRequest()
        
        service.request(searchRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.printDebug("CAN- SUCCESS")
                self.serverList = response.servers
                self.setSelectedServer(server: response.servers.first)
            case .failure(let error):
                self.printDebug("CAN- FAIL")
                self.printDebug(error.localizedDescription)
            }
        }
    }
    
    private func setTunnelStateUI() {
        switch tunnelState {
        case .connecting:
            DispatchQueue.main.async {
                self.setUI(state: .connecting)
            }
        case .disconnecting:
            DispatchQueue.main.async {
                self.setUI(state: .disconnecting)
            }
        case .failed:
            DispatchQueue.main.async {
                self.setUI(state: .disconnected)
            }
        }
    }
    
    private func setManagerStateUI() {
        if !boolInitialSet { return }
        switch vpnStatus {
        case .disconnected, .invalid:
            printDebug("CAN- Man Disconnected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.printDebug("CAN- Man delayed + Disconnected")
                self.mainView.setState(state: .disconnected)
            }
        case .connected:
            printDebug("CAN- Man Connected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.printDebug("CAN- Man delayed + Connected")
                self.mainView.setState(state: .connected)
            }
        case .connecting, .disconnecting, .reasserting:
            printDebug("CAN- Man Break")
            break
        @unknown default:
            break
        }
    }
    
    private func setInitialStateUI(state: NEVPNStatus) {
        boolInitialSet = true
        switch state {
        case .invalid, .disconnected:
            DispatchQueue.main.async {
                self.mainView.setState(state: .disconnected)
                self.printDebug("CAN- init disconnected")
            }
        case .connected:
            DispatchQueue.main.async {
                self.mainView.setState(state: .connected)
                self.printDebug("CAN- init connected")
            }
        case .connecting, .disconnecting, .reasserting:
            break
        @unknown default:
            break
        }
    }
    
}

// MARK: Set selected Country

extension MainScreenViewController {
    
    private func setSelectedServer(server: Server?) {
        DispatchQueue.main.async {
            self.mainView.setLocationFlag(countryCode: server?.location.countryCode.lowercased())
            self.mainView.setLocationText(country: server?.location.city, ip: server?.connection.host)
            self.mainView.setLocationSignal(level: .good)
        }
    }
    
}

// MARK: VPN manager interactions
extension MainScreenViewController: MainScreenViewDelegate {
    func goProButtonTapped() {
        //TODO: present go Pro VC
        let goProViewController = GoPremiumViewController()
        goProViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(goProViewController, animated: true)
    }
    
    func locationButtonTapped() {
        //TODO: present country selection VC
        let locationViewController = LocationViewController(serverList: serverList)
        locationViewController.hidesBottomBarWhenPushed = true
        locationViewController.delegate = self
        self.navigationController?.pushViewController(locationViewController, animated: true)
    }
    
    func changeStateTapped() {
        guard let manager = tunnelManager else { return }
        manager.changeVPNState()
    }
}


// MARK: NETunnelManagerDelegate
extension MainScreenViewController: NETunnelManagerDelegate {
    func initialState(state: NEVPNStatus) {
        setInitialStateUI(state: state)
    }
    
    func stateChanged(state: TunnelState) {
        tunnelState = state
        setTunnelStateUI()
    }
}

// MARK: Print helper for now:
extension MainScreenViewController {
    private func printDebug(_ string: String) {
        #if DEBUG
        print(string)
        #endif
    }
    
}

// MARK: LocationViewControllerDelegate
extension MainScreenViewController: LocationViewControllerDelegate {
    func selectedServer(server: Server) {
        setSelectedServer(server: server)
    }
    
}
