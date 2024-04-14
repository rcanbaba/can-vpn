//
//  ViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 19.12.2022.
//

import UIKit
import NetworkExtension
import FirebaseAnalytics
import MapKit
import StoreKit

class MainScreenViewController: UIViewController {
    
    private lazy var mainView = MainScreenView()
    
    private var tunnelManager: NETunnelManager?
    //  private var ipSecManager: VPNManager?
    
    private var networkService: DefaultNetworkService?
    
    private var selectedServer: Server?
    private var selectedServerConfig: Configuration?
    
    private var popupPresenterViewController: PopupPresenterViewController?
    private var ratingPopupViewController: RatingPopupViewController?
    
    private var getFreeAnimationTimer: Timer?
    
    private var userTriggeredConnection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("001_MainScreenPresented", parameters: ["type" : "didload"])
        
        // to ipsec manager
        //  NotificationCenter.default.addObserver(self, selector: #selector(statusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        mainView.delegate = self
        
        tunnelManager = NETunnelManager()
        tunnelManager?.delegate = self
        // ipSecManager = VPNManager()
        networkService = DefaultNetworkService()
        addNotifications()
        setLocationButtonInitialData()
        configureUI()
        checkSubscriptionState()
        checkSubscriptionPageThenPresent()
        checkGetFreeThenSet()
        observeNotifications()
        requestTrackingPermission()
        setupMenuButton()
    }
    
    private let sideMenuWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private var sideMenu: SideMenuViewController?
    private var isSideMenuOpen = false
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name.languageChanged, object: nil)
    }
    
    @objc func updateLanguage() {
        DispatchQueue.main.async {
            self.mainView.reloadLocalization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("002MainScreenPresented", parameters: ["type" : "willAppear"])
        setNavigationBar()
        playGetFreeAnimationAfterDelay()
        startAnimationTimer()
        checkRatingPopupThenPresent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimationTimer()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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
        mainView.setGetFreeView(isHidden: isPremium)
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
        let shouldShowGetFreePopup = LaunchCountManager.shared.shouldShowGetFreePopup()
        mainView.setGetFreeView(isHidden: !shouldShowGetFreePopup)
        shouldShowGetFreePopup ? playGetFreeAnimationAfterDelay() : ()
        shouldShowGetFreePopup ? presentEmailPopup() : ()
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
        guard ratingPopupViewController == nil else { return }
        guard popupPresenterViewController == nil else { return }
        
        let freePopupView = GetFreePopupView()
        freePopupView.delegate = self
        
        popupPresenterViewController = PopupPresenterViewController()
        popupPresenterViewController!.popupView = freePopupView
        popupPresenterViewController!.modalPresentationStyle = .overFullScreen
        popupPresenterViewController!.modalTransitionStyle  = .crossDissolve
        self.present(popupPresenterViewController!, animated: true, completion: nil)
    }
    
    private func checkRatingPopupThenPresent() {
        RatingCountManager.shared.shouldShowPopup() ? presentRatingPopup() : ()
    }
    
    private func presentRatingPopup() {
        // already presenting
        guard popupPresenterViewController == nil else { return }
        guard ratingPopupViewController == nil else { return }
        ratingPopupViewController = RatingPopupViewController()
        ratingPopupViewController!.modalPresentationStyle = .overFullScreen
        ratingPopupViewController!.modalTransitionStyle  = .crossDissolve
        ratingPopupViewController!.delegate = self
        present(ratingPopupViewController!, animated: true)
    }
    
    private func presentSpecialOffer() {
        // TODO: bunların üstüne ayrı bişeyle present etsi
        let controller = SpecialOfferViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle  = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    public func presentLocationPage() {
        Analytics.logEvent("011_PresentLocationScreen", parameters: ["type" : "present"])
        let locationViewController = LocationViewController()
        locationViewController.hidesBottomBarWhenPushed = true
        locationViewController.delegate = self
        self.navigationController?.pushViewController(locationViewController, animated: true)
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
        Analytics.logEvent("003_MainScreenPresented", parameters: ["type" : "enterForeground"])
        guard let manager = tunnelManager,let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "Error occurred, please reload app.")
            Analytics.logEvent("096_ChangeState", parameters: ["error" : "guard"])
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
               // self.getIPAddress()
                
            case .failure(_):
                self.setMainUI(state: .disconnected)
                self.printDebug("getCredential failure")
                Toaster.showToast(message: "error_location_again".localize())
                Analytics.logEvent("003_API_getCredentialRequest", parameters: ["error" : "happened"])
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
                    DispatchQueue.main.async {
                        self.mainView.setLocationIP(text: response.ipAddress)
                    }
                case .failure(_):
                    self.printDebug("getIPAddressRequest failure")
                    Analytics.logEvent("009_API_getIPAddressRequest", parameters: ["error" : "happened"])
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
                    Toaster.showToast(message: "coupon_generate_success".localize())
                }
            case .failure(let error):
                let errorMessage = ErrorHandler.getErrorMessage(for: error)
                Toaster.showToast(message: errorMessage)
                Analytics.logEvent("005_API_generateCouponRequest", parameters: ["error" : "happened"])
            }
        }
    }
    
}

// MARK: - Set Selected Server
extension MainScreenViewController {
    private func setSelectedServer(server: Server?) {      
        RatingCountManager.shared.incrementConnectCount()
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
                    Analytics.logEvent("082_ChangeState", parameters: ["error" : "selectedServer nil"])
                }
            } else if currentManagerState == .connected {
                manager.disconnectFromWg()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let selectedServer = self.selectedServer {
                        DispatchQueue.main.async {
                            self.setMainUI(state: .connecting)
                            self.getCredential(serverId: selectedServer.id)
                            self.setSelectedServerData(server: server)
                        }
                    } else {
                        Toaster.showToast(message: "error_occur_location".localize())
                        Analytics.logEvent("081_ChangeState", parameters: ["error" : "selectedServer nil"])
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
        KeyValueStorage.lastConnectedLocation = server
        DispatchQueue.main.async {
            self.mainView.setLocationFlag(countryCode: server?.location.countryCode.lowercased())
            self.mainView.setLocationCountry(text: server?.location.city)
            self.mainView.setLocationSignal(level: server?.ping)
            self.setMapRegionToSelectedLocation(server: server)
        }
    }
    
    private func handleAlreadyConnectedIfPossible() {
        guard !userTriggeredConnection else { return }
        if let lastConnectedLocation = KeyValueStorage.lastConnectedLocation {
            setSelectedServerData(server: lastConnectedLocation)
        }
    }
}

// MARK: - Side Menu
extension MainScreenViewController {
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

// MARK: - MainScreenViewDelegate
extension MainScreenViewController: MainScreenViewDelegate {
    func sideMenuButtonTapped() {
        toggleSideMenu()
    }
    
    func getFreeTapped() {
        presentEmailPopup()
    }
    
    func goProButtonTapped() {
        
        presentSpecialOffer()
        
        // TODO:
      //  presentSubscriptionPage()
    }
    
    func locationButtonTapped() {
        presentLocationPage()
    }
    
    func changeStateTapped() {
        RatingCountManager.shared.incrementConnectCount()
        userTriggeredConnection = true
        guard let manager = tunnelManager, let currentManagerState = manager.getManagerState() else {
            Toaster.showToast(message: "error_try_again".localize())
            Analytics.logEvent("097_ChangeState", parameters: ["error" : "guard"])
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
                Analytics.logEvent("098_ChangeState", parameters: ["error" : "selectedServer nil"])
            }
        } else if currentManagerState == .connected {
            manager.disconnectFromWg()
        } else {
            Toaster.showToast(message: "error_try_again".localize())
            Analytics.logEvent("099_ChangeState", parameters: ["error" : "connectedElse"])
        }
    }
}


// MARK: - NETunnelManagerDelegate
extension MainScreenViewController: NETunnelManagerDelegate {
    func stateChanged(state: NEVPNStatus) {
        setState(state: state)
        state == .connected ? handleAlreadyConnectedIfPossible() : ()
        state == .connected ? getIPAddress() : ()
    }
}

// MARK: - LocationViewControllerDelegate
extension MainScreenViewController: LocationViewControllerDelegate {
    func selectedServer(server: Server) {
        userTriggeredConnection = true
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

//MARK: - Set MAP
extension MainScreenViewController {
    private func setMapRegionToSelectedLocation(server: Server?) {
        guard let server = server else { return }
        let coordinate = CLLocationCoordinate2D(latitude: server.location.latitude, longitude: server.location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mainView.mapView.setRegion(region, animated: true)
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

//MARK: - Rating Popup
extension MainScreenViewController: RatingPopupViewControllerDelegate {
    func didTapRateButton(_ controller: RatingPopupViewController, rate: Int) {
        Analytics.logEvent("RatingPopupPresented", parameters: ["rate" : "\(rate)"])
        closeRatingPopup()
        if rate >= 4 {
            Analytics.logEvent("RatingRatedHigh", parameters: ["rate" : "High"])
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            RatingCountManager.shared.userGaveHighRating()
        } else {
            Analytics.logEvent("RatingRatedLow", parameters: ["rate" : "Low"])
            RatingCountManager.shared.userGaveLowRating()
            Toaster.showToast(message: "rating_thank_you".localize())
        }
    }
    
    func didTapCancelButton(_ controller: RatingPopupViewController) {
        Analytics.logEvent("RatingPopupCancelled", parameters: [:])
        RatingCountManager.shared.resetAllCount()
        closeRatingPopup()
    }
    
    private func closeRatingPopup() {
        ratingPopupViewController?.dismiss(animated: true, completion: {[weak self] in
            guard let self = self else { return }
            self.ratingPopupViewController = nil
        })
    }
}

//MARK: - Special Offer Popup
extension MainScreenViewController: SpecialOfferViewControllerDelegate {
    func getButtonTapped(view: SpecialOfferViewController) {
        
    }
    
    func closeButtonTapped(view: SpecialOfferViewController) {
        
    }
    

}
