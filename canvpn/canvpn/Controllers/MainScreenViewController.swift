//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import NetworkExtension
import FirebaseAnalytics

class MainScreenViewController: UIViewController {
    
    private lazy var mainView = MainScreenView()
    
    private var tunnelManager: NETunnelManager?
    //  private var ipSecManager: VPNManager?
    
    private var vpnStatus: NEVPNStatus = .invalid
    
    private var networkService: DefaultNetworkService?
    
    private var selectedServer: Server?
    private var selectedServerConfig: Configuration?
    
    private var popupPresenterViewController: PopupPresenterViewController?
    
    private var getFreeAnimationTimer: Timer?
    
    //TODO: alttan yukarı gelince ne oluyor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("001-MainScreenPresented", parameters: ["type" : "didload"])
        
        // to ipsec manager
        //  NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
        // ipSecManager = VPNManager()
        
        networkService = DefaultNetworkService()
        
        setLocationButtonInitialData()
        configureUI()
        checkSubscriptionState()
        checkSubscriptionPageThenPresent()
        checkGetFreeThenSet()
        observeNotifications()
        requestTrackingPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("002-MainScreenPresented", parameters: ["type" : "willAppear"])
        setNavigationBar()
        playGetFreeAnimationAfterDelay()
        startAnimationTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimationTimer()
    }
    
    private func setNavigationBar() {
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func setLocationButtonInitialData() {
        if let initialServer = SettingsManager.shared.settings?.servers.first(where: {!$0.type.isPremium()}) {
            selectedServer = initialServer
            mainView.setLocationSignal(level: initialServer.ping)
            mainView.setLocationCountry(text: initialServer.location.city)
            mainView.setLocationFlag(countryCode: initialServer.location.countryCode.lowercased())
        }
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
    
    private func checkSubscriptionState() {
        let isPremium = SettingsManager.shared.settings?.user.isSubscribed ?? false
        isPremium ? setPremiumUser() : setStandardUser()
    }
    
    private func setPremiumUser() {
        mainView.goProButton.setState(isPremium: true)
    }
    
    private func setStandardUser() {
        mainView.goProButton.setState(isPremium: false)
    }
    
    private func checkSubscriptionPageThenPresent() {
        let isPremium = SettingsManager.shared.settings?.interface.showPurchase ?? false
        isPremium ? presentSubscriptionPage() : ()
    }
    
    private func checkGetFreeThenSet() {
        mainView.setGetFreeView(isHidden: !LaunchCountManager.shared.shouldShowPopup())
        LaunchCountManager.shared.shouldShowPopup() ? playGetFreeAnimationAfterDelay() : ()
        LaunchCountManager.shared.shouldShowPopup() ? presentEmailPopup() : ()
    }
    
    private func presentSubscriptionPage() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
    private func playGetFreeAnimationAfterDelay() {
        mainView.getFreeLabel.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.mainView.getFreeAnimation.play()
            UIView.animate(withDuration: 0.2, delay: 1.6) { [weak self] in
                self?.mainView.getFreeLabel.alpha = 1.0
            }
        }
    }
    
    private func presentEmailPopup() {
        // already presenting
        guard popupPresenterViewController == nil else { return }
        
        let freePopupView = GetFreePopupView()
        freePopupView.delegate = self
        
        popupPresenterViewController = PopupPresenterViewController()
        popupPresenterViewController!.popupView = freePopupView
        popupPresenterViewController!.modalPresentationStyle = .overFullScreen
        popupPresenterViewController!.modalTransitionStyle  = .crossDissolve
        self.present(popupPresenterViewController!, animated: true, completion: nil)
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
        
    }
    
    @objc private func willEnterForegroundNotification(_ sender: Notification) {
        Analytics.logEvent("003-MainScreenPresented", parameters: ["type" : "enterForeground"])
        guard let manager = tunnelManager,let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "Error occurred, please reload app.")
            Analytics.logEvent("096-ChangeState", parameters: ["error" : "guard"])
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
    
    @objc private func subscriptionStateUpdated (_ notification: Notification) {
        checkSubscriptionState()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard let service = self.networkService else { return }
            var getIPAddressRequest = GetIPAddressRequest()
            getIPAddressRequest.setParams()
            
            service.request(getIPAddressRequest) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.printDebug("getIPAddressRequest success \(response.ipAddress)")
                    DispatchQueue.main.async {
                        self.mainView.setLocationIP(text: response.ipAddress)
                    }
                case .failure(_):
                    self.printDebug("getIPAddressRequest failure")
                    Analytics.logEvent("009-API-getIPAddressRequest", parameters: ["error" : "happened"])
                }
            }
        }
    }
    
    private func getFreeCouponRequest(email: String) {
        guard let service = networkService else { return }
        var generateCouponRequest = GenerateCouponRequest()
        generateCouponRequest.setParams(email: email)
        
        service.request(generateCouponRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.printDebug("generateCouponRequest success")
                LaunchCountManager.shared.resetLaunchCount()
                DispatchQueue.main.async {
                    self.mainView.setGetFreeView(isHidden: true)
                }
            case .failure(let error):
                let errorMessage = ErrorHandler.getErrorMessage(for: error)
                Toaster.showToast(message: errorMessage)
                Analytics.logEvent("005-API-generateCouponRequest", parameters: ["error" : "happened"])
            }
        }
    }
    
}

// MARK: - Set Selected Server
extension MainScreenViewController {
    private func setSelectedServer(server: Server?) {        
        if server?.id == selectedServer?.id {
            selectedServer = server
            setSelectedServerData(server: server)
            return
        }
        selectedServer = server
        DispatchQueue.main.async {
            self.mainView.setLocationIP(text: nil)
        }
        
        if let manager = tunnelManager, let currentManagerState = manager.getManagerState() {
            if currentManagerState == .disconnected {
                if let selectedServer = selectedServer {
                    DispatchQueue.main.async {
                        self.setMainUI(state: .connecting)
                        self.getCredential(serverId: selectedServer.id)
                        self.setSelectedServerData(server: server)
                    }
                } else {
                    Toaster.showToast(message: "error_occur_location".localize())
                    Analytics.logEvent("082-ChangeState", parameters: ["error" : "selectedServer nil"])
                }
            } else if currentManagerState == .connected {
                manager.disconnectFromWg()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    if let selectedServer = self.selectedServer {
                        DispatchQueue.main.async {
                            self.setMainUI(state: .connecting)
                            self.getCredential(serverId: selectedServer.id)
                            self.setSelectedServerData(server: server)
                        }
                    } else {
                        Toaster.showToast(message: "error_occur_location".localize())
                        Analytics.logEvent("081-ChangeState", parameters: ["error" : "selectedServer nil"])
                    }
                }
            } else {
                Toaster.showToast(message: "error_try_again".localize())
            }
        } else {
            setSelectedServerData(server: server)
        }
    }
    
    private func setSelectedServerData(server: Server?) {
        DispatchQueue.main.async {
            self.mainView.setLocationFlag(countryCode: server?.location.countryCode.lowercased())
            self.mainView.setLocationCountry(text: server?.location.city)
            self.mainView.setLocationSignal(level: server?.ping)
        }
    }
}

// MARK: - MainScreenViewDelegate
extension MainScreenViewController: MainScreenViewDelegate {
    func getFreeTapped() {
        presentEmailPopup()
    }
    
    func goProButtonTapped() {
        presentSubscriptionPage()
    }
    
    func locationButtonTapped() {
        Analytics.logEvent("011-PresentLocationScreen", parameters: ["type" : "present"])
        let locationViewController = LocationViewController()
        locationViewController.hidesBottomBarWhenPushed = true
        locationViewController.delegate = self
        self.navigationController?.pushViewController(locationViewController, animated: true)
    }
    
    func changeStateTapped() {
        guard let manager = tunnelManager, let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "error_occur_1".localize())
            Analytics.logEvent("097-ChangeState", parameters: ["error" : "guard"])
            return }
        
        if currentManagerState == .disconnected {
            // TO CONNECT
            if let selectedServer = selectedServer {
                DispatchQueue.main.async {
                    self.setMainUI(state: .connecting)
                    self.getCredential(serverId: selectedServer.id)
                }
            } else {
                Toaster.showToast(message: "error_occur_location".localize())
                Analytics.logEvent("098-ChangeState", parameters: ["error" : "selectedServer nil"])
            }
        } else if currentManagerState == .connected {
            manager.disconnectFromWg()
        } else {
            Toaster.showToast(message: "error_try_again".localize())
            Analytics.logEvent("099-ChangeState", parameters: ["error" : "connectedElse"])
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
    }
    
}

// MARK: - GetFreePopupViewDelegate
extension MainScreenViewController: GetFreePopupViewDelegate {
    func getButtonTapped(view: GetFreePopupView, email: String) {
        getFreeCouponRequest(email: email)
        popupPresenterViewController?.dismiss(animated: true, completion: {[weak self] in
            guard let self = self else { return }
            self.popupPresenterViewController = nil
        })
    }
    
    func closeButtonTapped(view: GetFreePopupView) {
        popupPresenterViewController?.dismiss(animated: true, completion: {[weak self] in
            guard let self = self else { return }
            self.popupPresenterViewController = nil
        })
    }
}

// MARK: ~ GetFree Flow Related Methods
extension MainScreenViewController {
    func startAnimationTimer() {
        // Invalidate any existing timer before creating a new one
        getFreeAnimationTimer?.invalidate()
        getFreeAnimationTimer = Timer.scheduledTimer(timeInterval: Constants.getFreeAnimationDuration,
                                                     target: self,
                                                     selector: #selector(startGetFreeAnimation),
                                                     userInfo: nil,
                                                     repeats: true)
    }

    func stopAnimationTimer() {
        getFreeAnimationTimer?.invalidate()
        getFreeAnimationTimer = nil
    }

    @objc func startGetFreeAnimation() {
        playGetFreeAnimationAfterDelay()
    }
}

//MARK: - App Tracking Transparency
extension MainScreenViewController {
    func requestTrackingPermission() {
        TrackingManager.shared.requestTrackingPermission { (status) in
            self.printDebug("ATTracking completed, status: \(status)")
        }
    }
}
