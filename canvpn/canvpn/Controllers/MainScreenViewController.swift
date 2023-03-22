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
    
    var vpnServerList: [VpnServerItem] = []
    
    var boolInitialSet: Bool = false
    
    private func createMockData() {
        let item1 = VpnServerItem(ip: "3.86.250.76", username: "vpnserver", password: "vpnserver", secret: "vpnserver", isFree: true, region: "", country: "Atlanta", countryCode: "us", isSelected: true)
        let item2 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Germany", countryCode: "de")
        let item3 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Virginia", countryCode: "tr")
        let item4 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Singapore", countryCode: "dm")
        let item5 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Greece", countryCode: "gr")
        let item6 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Adana", countryCode: "gy")
        let item7 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Çorum", countryCode: "gb")
        let item8 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "İstanbul", countryCode: "ad")
        vpnServerList.append(contentsOf: [item1, item2, item3, item4, item5, item6, item7, item8])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("custom_event_can", parameters: ["deneme" : "134133"])
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
       // ipSecManager = VPNManager()
        
        networkService = DefaultNetworkService()
        networkRequest()
        createMockData()
        configureUI()
        
        setLocationButtonMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: disappear da default a çekebilirsin
        UIApplication.shared.statusBarStyle = .darkContent
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
    
    public func createRequest(qMes: String, location: String, method: String , completionBlock: @escaping (String) -> Void) -> Void
      {
          let requestURL = URL(string: location)
          var request = URLRequest(url: requestURL!)

          request.httpMethod = method
          request.httpBody = qMes.data(using: .utf8)

          let requestTask = URLSession.shared.dataTask(with: request) {
              (data: Data?, response: URLResponse?, error: Error?) in

              if(error != nil) {
                  self.printDebug("CAN- Error: \(error)")
              }else
              {

                  let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                  //send this block to required place
                  completionBlock(outputStr!);
              }
          }
          requestTask.resume()
      }
    
    func networkRequest() {
        guard let service = networkService else { return }
        let searchRequest = SearchCompanyRequest()
        service.request(searchRequest) { [weak self] result in
            switch result {
            case .success(let companies):
                self?.printDebug("CAN- SUCCESS")
            case .failure(let error):
                self?.printDebug("CAN- FAIL")
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

// MARK: VPN manager interactions
extension MainScreenViewController: MainScreenViewDelegate {
    func locationButtonTapped() {
        //TODO: present country selection VC
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
