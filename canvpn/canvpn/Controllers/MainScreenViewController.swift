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
        manager.localizedDescription = "canVPN"
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
            print("NOTIF: invalid")
        case .disconnected:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.connectionUIState = .disconnected
            }
            print("NOTIF: disconnected")
        case .connecting:
            connectionUIState = .connecting
            print("NOTIF: connecting")
        case .connected:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.connectionUIState = .connected
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerListTableViewCell", for: indexPath) as! ServerListTableViewCell
        
        cell.backgroundColor = UIColor.Custom.cellBg
        cell.isChecked = false
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.Custom.selectedCellBg
        cell.selectedBackgroundView = bgColorView
        
        if indexPath.row == 0 {
            cell.countryNameLabel.text = "Atlanta" + " \(indexPath.row)"
            cell.isChecked = true
            cell.flagImageView.image = UIImage(named: "us")
        } else if indexPath.row == 1 {
            cell.countryNameLabel.text = "Germany" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "tr")
        }
        else if indexPath.row == 2 {
            cell.countryNameLabel.text = "Virgina" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "de")
        }
        else if indexPath.row == 3 {
            cell.countryNameLabel.text = "Singapore" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "dm")
        }
        else if indexPath.row == 4 {
            cell.countryNameLabel.text = "Germany17" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "gr")
        }
        else if indexPath.row == 5 {
            cell.countryNameLabel.text = "Adana" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "gy")
        }
        else if indexPath.row == 6 {
            cell.countryNameLabel.text = "Istanbul" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "gb")
        }
        else if indexPath.row == 7 {
            cell.countryNameLabel.text = "Argentina" + " \(indexPath.row)"
            cell.flagImageView.image = UIImage(named: "ad")
        }
        
        
        return cell
    }
    
    
    
}
