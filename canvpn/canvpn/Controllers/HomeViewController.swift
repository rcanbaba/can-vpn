//
//  HomeViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 27.11.2023.
//

import UIKit
import NetworkExtension
import FirebaseAnalytics
import MapKit

class HomeViewController: UIViewController {
    
    private lazy var homeView = HomeScreenView()

    private let sideMenuWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private var sideMenu: SideMenuViewController?
    private var isSideMenuOpen = false
    private var serverList: [Server] = []
    
    private var selectedServer: Server?
    private var selectedServerConfig: Configuration?
    
    private var networkService: DefaultNetworkService?
    private var tunnelManager: NETunnelManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("001-HomeVCPresented", parameters: ["type" : "didload"])
        networkService = DefaultNetworkService()
        tunnelManager = NETunnelManager()
        setInitialServerData()
        setDelegates()
        observeNotifications()
        addVPNServerAnnotations()
        configureUI()
        setup3DMapView()
        setNavigationBar()
        setSubscriptionState()
        setupMenuButton()
    }
    
    private func setInitialServerData() {
        serverList = (SettingsManager.shared.settings?.servers ?? []).reversed()
        selectedServer = serverList.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("002-MainScreenPresented", parameters: ["type" : "willAppear"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func configureUI() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setDelegates() {
        tunnelManager?.delegate = self
        homeView.delegate = self
        homeView.pickerView.delegate = self
        homeView.pickerView.dataSource = self
        homeView.mapView.delegate = self
    }

    private func observeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(subscriptionStateUpdated(_:)),
                                               name: .subscriptionStateUpdated,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLanguage),
                                               name: NSNotification.Name.languageChanged,
                                               object: nil)
        
    }
    
    @objc private func willEnterForegroundNotification(_ sender: Notification) {
        // TODO: restore vpn manager state
    }
    
    @objc private func subscriptionStateUpdated (_ notification: Notification) {
        setSubscriptionState()
    }
    
    @objc func updateLanguage() {
        DispatchQueue.main.async {
            self.homeView.reloadLocalization()
        }
    }
    
    private func setSubscriptionState() {
        let isPremium = SettingsManager.shared.settings?.user.isSubscribed ?? false
        homeView.goProButton.isHidden = isPremium
    }
    
    private func presentSubscriptionPage() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
    private func checkPremiumSelectionPossible(server: Server) -> Bool {
        if server.type.isPremium() && SettingsManager.shared.settings?.user.isSubscribed == false {
            return false
        } else {
            return true
        }
    }
    
    private func freeUserTryToConnectPremium() {
        Toaster.showToast(message: "free_user_selected_premium_message".localize())
        homeView.shakeGoProButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.presentSubscriptionPage()
        }
    }
    
    private func setMainUI(state: ConnectionState) {
        DispatchQueue.main.async {
            self.homeView.setState(state: state)
        }
    }
    
    private func setMainUI(ipText: String) {
        DispatchQueue.main.async {
            self.homeView.setIpLabel(text: ipText)
        }
    }
}

// MARK: - Connection methods
extension HomeViewController {
    private func startConnection(forSelectedServer server: Server?) {
        if let selectedServer = server {
            if checkPremiumSelectionPossible(server: selectedServer) {
                setMainUI(state: .connecting)
                getCredential(serverId: selectedServer.id)
            } else {
                freeUserTryToConnectPremium()
            }
        } else {
            Toaster.showToast(message: "error_occur_location".localize())
        }
    }
    
    private func startDisconnection(forManager manager: NETunnelManager) {
        manager.disconnectFromWg()
    }
    
    // Using Button
    private func changeState() {
        guard let manager = tunnelManager, let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "error_try_again".localize())
            return
        }

        switch currentManagerState {
        case .disconnected:
            startConnection(forSelectedServer: selectedServer)
        case .connected:
            startDisconnection(forManager: manager)
        default:
            Toaster.showToast(message: "error_try_again".localize())
        }
    }
    
    // Using Picker or Map
    private func setSelectedServer(server: Server?) {
        if server?.location.city == selectedServer?.location.city {
            return
        }
        selectedServer = server
        setMainUI(ipText: "")
        
        guard let manager = tunnelManager, let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "error_try_again".localize())
            return
        }

        switch currentManagerState {
        case .disconnected:
            startConnection(forSelectedServer: selectedServer)
        case .connected:
            startDisconnection(forManager: manager)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.startConnection(forSelectedServer: self?.selectedServer)
            }
        default:
            Toaster.showToast(message: "error_try_again".localize())
        }
    }
    
}

// MARK: - Side Menu
extension HomeViewController {
    private func setupMenuButton() {
        sideMenu = SideMenuViewController()
        addChild(sideMenu!)
        view.addSubview(sideMenu!.view)
        sideMenu!.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: UIScreen.main.bounds.height)
        sideMenu!.didMove(toParent: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMenu(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleSideMenu() {
        isSideMenuOpen.toggle()
        UIView.animate(withDuration: 0.3) {
            if self.isSideMenuOpen {
                self.sideMenu!.view.frame.origin.x = 0
            } else {
                self.sideMenu!.view.frame.origin.x = -self.sideMenuWidth
            }
        }
    }
    
    @objc func handleTapOutsideMenu(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if isSideMenuOpen && location.x > sideMenuWidth {
            toggleSideMenu()
        }
    }
}


// MARK: - API Calls
extension HomeViewController {
    
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
                self.getIPAddress()
                
            case .failure(_):
                self.setMainUI(state: .disconnected)
                self.printDebug("getCredential failure")
                Toaster.showToast(message: "error_location_again".localize())
                Analytics.logEvent("003-API-getCredentialRequest", parameters: ["error" : "happened"])
            }
            
        }
    }
    
    private func getIPAddress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let service = self.networkService else { return }
            let getIPAddressRequest = GetIPAddressRequest()
            
            service.request(getIPAddressRequest) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.printDebug("getIPAddressRequest success \(response.ipAddress)")
                    self.setMainUI(ipText: response.ipAddress)
                case .failure(_):
                    self.printDebug("getIPAddressRequest failure")
                    Analytics.logEvent("009-API-getIPAddressRequest", parameters: ["error" : "happened"])
                }
            }
        }
    }
    
}

//MARK: - HomeScreenViewDelegate
extension HomeViewController: HomeScreenViewDelegate {
    func changeStateTapped() {
        changeState()
    }
    func goProButtonTapped() {
        presentSubscriptionPage()
    }
    func sideMenuButtonTapped() {
        toggleSideMenu()
    }
}

// MARK: - NETunnelManagerDelegate
extension HomeViewController: NETunnelManagerDelegate {
    func stateChanged(state: NEVPNStatus) {
        setMainUI(state: state.getConnectionState())
    }
}

//MARK: - Map Methods
extension HomeViewController {
    private func addVPNServerAnnotations() {
        for server in serverList {
            let coordinate = CLLocationCoordinate2D(latitude: server.location.latitude, longitude: server.location.longitude)
            let annotation = CustomAnnotation(name: server.location.city, coordinate: coordinate, isPremium: server.type.isPremium())
            homeView.mapView.addAnnotation(annotation)
        }
    }
    
    private func setup3DMapView() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 45, longitude: 12) // Focus on the center of the map
        camera.pitch = 45.0 // Tilt angle in degrees
        camera.altitude = 7000000 // Altitude in meters
        camera.heading = 0 // Camera heading in degrees; north is 0
        
        homeView.mapView.camera = camera
        homeView.mapView.mapType = .satellite
    }
    
    private func setMapRegionToSelectedLocation(server: Server) {
        let coordinate = CLLocationCoordinate2D(latitude: server.location.latitude, longitude: server.location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300000, longitudinalMeters: 300000)
        homeView.mapView.setRegion(region, animated: true)
    }
}

//MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title, let index = serverList.firstIndex(where: { $0.location.city == title }) {
                let selectedItem = serverList[index]
                homeView.pickerView.selectRow(index, inComponent: 0, animated: true)
                setMapRegionToSelectedLocation(server: selectedItem)
                setSelectedServer(server: selectedItem)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "CustomAnnotationView"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView

        if view == nil {
            view = CustomAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            view?.annotation = annotation
        }

        view?.canShowCallout = false // We manage our own label
        return view
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serverList.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = serverList[row]
        setMapRegionToSelectedLocation(server: selectedItem)
        setSelectedServer(server: selectedItem)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var customView = view
        if customView == nil {
            customView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 30))
            
            let flagImageView = UIImageView(frame: CGRect(x: 24, y: 5, width: 28, height: 20))
            flagImageView.contentMode = .scaleToFill
            flagImageView.layer.cornerRadius = 2.0
            flagImageView.layer.borderWidth = 0.2
            flagImageView.layer.borderColor = UIColor.gray.cgColor
            customView?.addSubview(flagImageView)
            
            let countryLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.frame.width - 120, height: 30))
            countryLabel.font = UIFont.boldSystemFont(ofSize: 16)
            countryLabel.textColor = .black
            customView?.addSubview(countryLabel)
            
            let signalImageView = UIImageView(frame: CGRect(x: pickerView.frame.width - 50, y: 4, width: 26, height: 22))
            signalImageView.contentMode = .scaleAspectFit
            customView?.addSubview(signalImageView)
            
            let proImageView = UIImageView(frame: CGRect(x: pickerView.frame.width - 82, y: 4, width: 24, height: 22))
            proImageView.contentMode = .scaleAspectFit
            proImageView.image = UIImage(named: "pro-crown-icon")
            proImageView.isHidden = true
            customView?.addSubview(proImageView)
        }
        
        if let flagImageView = customView?.subviews[0] as? UIImageView {
            flagImageView.image = UIImage(named: serverList[row].location.countryCode.lowercased())
        }

        if let countryLabel = customView?.subviews[1] as? UILabel {
            countryLabel.text = serverList[row].location.city
        }

        if let signalImageView = customView?.subviews[2] as? UIImageView {
            signalImageView.image = SignalLevel(rawValue: serverList[row].ping)?.getSignalImage()
        }

        if let proImageView = customView?.subviews[3] as? UIImageView {
            proImageView.isHidden = !serverList[row].type.isPremium()
        }
        
        return customView!
    }
}

//MARK: - App Tracking Transparency
extension HomeViewController {
    func requestTrackingPermission() {
        TrackingManager.shared.requestTrackingPermission { (status) in
            self.printDebug("ATTracking completed, status: \(status)")
        }
    }
}
