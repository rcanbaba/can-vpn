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

class MainScreenViewController: UIViewController {
    
    private var connectionUIState =  ConnectionState.initial {
        didSet {
            setVPNStateUI()
        }
    }
    
    private lazy var mainView = MainScreenView()
    private lazy var splashView = SplashScreenView()
    
    private var vpnManager: NEVPNManager?
    private var vpnStatus: NEVPNStatus = .invalid
    
    private var networkService: DefaultNetworkService?
    
    private lazy var mainBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var initialAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named("logo-full-animation")
        view.loopMode = .playOnce
        view.clipsToBounds = false
        return view
    }()
    
    var vpnServerList : [VpnServerItem] = []
    
    private func createMockData() {
        var item1 = VpnServerItem(ip: "3.86.250.76", username: "vpnserver", password: "vpnserver", secret: "vpnserver", isFree: true, region: "", country: "Atlanta", countryCode: "us", isSelected: true)
        var item2 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Germany", countryCode: "de")
        var item3 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Virginia", countryCode: "tr")
        var item4 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Singapore", countryCode: "dm")
        var item5 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Greece", countryCode: "gr")
        var item6 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Adana", countryCode: "gy")
        var item7 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "Çorum", countryCode: "gb")
        var item8 = VpnServerItem(ip: "", username: "", password: "", secret: "", isFree: true, region: "", country: "İstanbul", countryCode: "ad")
        vpnServerList.append(contentsOf: [item1, item2, item3, item4, item5, item6, item7, item8])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(splashView)
        splashView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        splashView.delegate = self
        mainView.delegate = self
        mainView.serverListTableView.delegate = self
        mainView.serverListTableView.dataSource = self
        setVPNStateUI()
        
        vpnManager = NEVPNManager.shared()
        vpnStatus = vpnManager!.connection.status
        NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        networkService = DefaultNetworkService()
        
        loadPreferences {}
        
        deneme()
        setIPAddress(isVpnConnected: false)
        createMockData()
        mainView.serverListTableView.reloadData()
    }
    
    private func setIPAddress(isVpnConnected: Bool) {
        if !isVpnConnected {
            let IPAddress = IpAddressManager().getIPAddress()
            mainView.setIpAdress(text: IPAddress ?? "")
        } else {
            mainView.setIpAdress(text: "12.39.239.4")
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
                  print("Error: \(error)")
              }else
              {

                  let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                  //send this block to required place
                  completionBlock(outputStr!);
              }
          }
          requestTask.resume()
      }
    
    func deneme() {
        guard let service = networkService else { return }
        let searchRequest = SearchCompanyRequest()
        service.request(searchRequest) { [weak self] result in
            switch result {
            case .success(let companies):
                print("SUCCESS")
            case .failure(let error):
                print("FAIL")
            }
        }
        
    }
    

    
    private func setVPNStateUI() {
        switch connectionUIState {
        case .initial:
            mainView.setStateLabel(text: "initial")
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "Tap To Start")
            print("initial")
        case .connect:
            mainView.setStateLabel(text: "connect")
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "Connect")
            print("connect")
            
        case .connecting:
            mainView.setStateLabel(text: "connecting")
            mainView.setUserInteraction(isEnabled: false)
            
            mainView.setAnimation(name: "globeLoading")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "interaction closed")
            print("connecting")
            
        case .connected:
            mainView.setStateLabel(text: "connected")
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "connectedVPN")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "Disconnect")
            print("connected")
            
        case .disconnecting:
            mainView.setStateLabel(text: "disconnecting")
            mainView.setUserInteraction(isEnabled: false)
            
            mainView.setAnimation(name: "globeLoading")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .loop)
            mainView.setButtonText(text: "interaction closed")
            print("disconnecting")
            
        case .disconnected:
            mainView.setStateLabel(text: "disconnected")
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "Reconnect")
            print("disconnected")
            
        }
    }
    
    
    func saveAndConnect(_ account: String) {
        save(config: account) { [weak self] in
            _ = self?.connectVPN()
        }
    }
    
    func save(config: String, completion: @escaping () -> Void) {
        //  config.saveToDefaults()
        //   config.saveToDefaults()
        loadPreferences { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.saveVPNProtocol(account: config, completion: completion)
        }
    }
    

    func connectVPN() -> Bool {
        guard let manager = vpnManager else { return false }
        debugPrint("!!!!! Establishing Connection !!!!!")
        do {
            try manager.connection.startVPNTunnel()
            connectionUIState = .connecting
            return true
        } catch NEVPNError.configurationInvalid {
            connectionUIState = .initial
            debugPrint("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            connectionUIState = .initial
            debugPrint("Failed to start tunnel (configuration disabled)")
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            connectionUIState = .initial
            return false
        }
        connectionUIState = .initial
        return false
    }
    
    private func disconnect() {
        guard let manager = vpnManager else { return }
        manager.connection.stopVPNTunnel()
        connectionUIState = .disconnected
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
      //  var neVPNProtocol: NEVPNProtocol
        
        
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
        manager.localizedDescription = "iLoveVPN"
        manager.isEnabled = true
        
        
        manager.saveToPreferences { error in
            if let err = error {
                print("Failed to save Preferences: \(err.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    @objc private func statusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        let status = connection.status
        print("NOTIF: status", status.rawValue)
        handleVPNStatus(status)
        
    }
    
    private func handleVPNStatus(_ vpnStatus: NEVPNStatus) {
        switch vpnStatus {
        case .invalid:
            connectionUIState = .initial
            self.setIPAddress(isVpnConnected: false)
            print("NOTIF: invalid")
        case .disconnected:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.connectionUIState = .disconnected
                self.setIPAddress(isVpnConnected: false)
            }
            print("NOTIF: disconnected")
        case .connecting:
            connectionUIState = .connecting
            print("NOTIF: connecting")
        case .connected:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.connectionUIState = .connected
                self.setIPAddress(isVpnConnected: true)
            }
            print("NOTIF: connected")
        case .reasserting:
            connectionUIState = .connecting
            print("NOTIF: reasserting")
        case .disconnecting:
            connectionUIState = .disconnecting
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

extension MainScreenViewController: MainScreenViewDelegate {
    func changeStateTapped() {
        
        switch connectionUIState {
        case .initial:
            saveAndConnect("vpn-server")
        case .connecting:
            print("STATE NOT CHANGED")
        case .connect:
            saveAndConnect("vpn-server")
        case .connected:
            disconnect()
        case .disconnecting:
            print("STATE NOT CHANGED")
        case .disconnected:
            saveAndConnect("vpn-server")
        }
        
        
    }
}

extension MainScreenViewController: SplashScreenViewDelegate {
    func splashAnimationCompleted() {
        splashView.hideWithAnimation { [weak self] in
            self?.splashView.removeFromSuperview()
        }
    }
    
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vpnServerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerListTableViewCell", for: indexPath) as! ServerListTableViewCell
        
        cell.backgroundColor = UIColor.Custom.cellBg
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.Custom.selectedCellBg
        cell.selectedBackgroundView = bgColorView
        
        let cellData = vpnServerList[indexPath.row]
        
        cell.countryNameLabel.text = cellData.country
        cell.isChecked = cellData.isSelected
        cell.flagImageView.image = UIImage(named: cellData.countryCode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isSelected = vpnServerList[indexPath.row].isSelected
        var tempArray = [VpnServerItem]()
        for item in vpnServerList {
            var newItem = item
            newItem.isSelected = false
            tempArray.append(newItem)
        }
        vpnServerList = tempArray
        vpnServerList[indexPath.row].isSelected = !isSelected
        mainView.serverListTableView.reloadData()
        
    }
    
    
    
}
