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
    private lazy var appNameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.orange
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.Text.white
        label.textAlignment = .center
        label.text = Constants.appNavBarName
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
          make.center.equalToSuperview()
        }
        return view
    }()
    
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
        Analytics.logEvent("custom_event_can", parameters: ["deneme" : "134133"])
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        mainView.navigationBarBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight + navigationBarHeight)
        }
        
        mainView.delegate = self
        mainView.serverListTableView.delegate = self
        mainView.serverListTableView.dataSource = self
        
        tunnelManager = NETunnelManager()
       // ipSecManager = VPNManager()
        
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
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = color
            self.navigationController?.navigationBar.backgroundColor = color
            self.navigationController?.navigationBar.barTintColor = color
            self.mainView.setColor(color)
            self.navigationItem.titleView = self.appNameView
        }

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
}

// MARK: VPN manager interactions
extension MainScreenViewController: MainScreenViewDelegate {
    func changeStateTapped() {
        guard let manager = tunnelManager else { return }
        manager.changeVPNState()
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
