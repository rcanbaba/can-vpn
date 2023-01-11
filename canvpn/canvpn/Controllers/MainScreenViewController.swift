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
    
    private var vpnManager: NEVPNManager?
    private var vpnStatus: NEVPNStatus = .invalid
    private var tunnelManager: NETunnelManager?
    private var ipSecManager: VPNManager?
    private var networkService: DefaultNetworkService?
    
    var vpnServerList : [VpnServerItem] = []
    
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
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setMainColor(state: .connected)
        
        mainView.delegate = self
        mainView.serverListTableView.delegate = self
        mainView.serverListTableView.dataSource = self
        
        setVPNStateUI()
        
        tunnelManager = NETunnelManager()
        ipSecManager = VPNManager()
                
        vpnStatus = .invalid
        
        networkService = DefaultNetworkService()
        
        networkRequest()
        setIPAddress(isVpnConnected: false)
        createMockData()
        mainView.reloadTableView()
    }
    
    private func setMainColor(state: ConnectionState) {
        var color: UIColor = UIColor.Custom.orange
        if state == .disconnected || state == .initial {
            color = UIColor.Custom.orange
        } else {
            color = UIColor.Custom.green
        }
        navigationController?.navigationBar.tintColor = color
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
        mainView.setColor(color)
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
    
    func networkRequest() {
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
            mainView.setStateLabel(text: "initial_key")
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "initial_key".localize())
            print("initial")
        case .connect:
            mainView.setStateLabel(text: "connect_key".localize())
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "connect_key".localize())
            print("connect")
            
        case .connecting:
            mainView.setStateLabel(text: "connecting_key".localize())
            mainView.setUserInteraction(isEnabled: false)
            
            mainView.setAnimation(name: "globeLoading")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "interaction closed")
            print("connecting")
            
        case .connected:
            mainView.setStateLabel(text: "connected_key".localize())
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "connectedVPN")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "discconnect_key".localize())
            print("connected")
            
        case .disconnecting:
            mainView.setStateLabel(text: "disconnecting_key".localize())
            mainView.setUserInteraction(isEnabled: false)
            
            mainView.setAnimation(name: "globeLoading")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .loop)
            mainView.setButtonText(text: "interaction closed")
            print("disconnecting")
            
        case .disconnected:
            mainView.setStateLabel(text: "disconnected_key".localize())
            mainView.setUserInteraction(isEnabled: true)
            
            mainView.setAnimation(name: "")
            mainView.setAnimation(isHidden: false)
            mainView.playAnimation(loopMode: .playOnce)
            mainView.setButtonText(text: "connect_key".localize())
            print("disconnected")
            
        }
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

// MARK: VPN manager interactions
extension MainScreenViewController: MainScreenViewDelegate {
    func changeStateTapped() {
        guard let manager = ipSecManager else { return }
        manager.changeVPNState(currentState: .disconnected, selectedVPN: vpnServerList[0])
      //  manager.changeVPNState()
        
//        switch connectionUIState {
//        case .initial:
//            saveAndConnect("vpn-server")
//        case .connecting:
//            print("STATE NOT CHANGED")
//        case .connect:
//            saveAndConnect("vpn-server")
//        case .connected:
//            disconnect()
//        case .disconnecting:
//            print("STATE NOT CHANGED")
//        case .disconnected:
//            saveAndConnect("vpn-server")
//        }
        
        
    }
}

// MARK: TableView, UITableViewDelegate & UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vpnServerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerListTableViewCell", for: indexPath) as! ServerListTableViewCell
        
        cell.backgroundColor = UIColor.Custom.cellBg
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
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
        mainView.reloadTableView()
    }
}
