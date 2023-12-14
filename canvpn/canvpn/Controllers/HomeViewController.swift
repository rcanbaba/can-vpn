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
    private var sideMenu: SideMenuViewController!
    private var isSideMenuOpen = false
    private var menuButton: UIButton?
    private let serverList = SettingsManager.shared.settings?.servers ?? []
    private var selectedServer: Server?
    
    private var networkService: DefaultNetworkService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        
        Analytics.logEvent("001-HomeVCPresented", parameters: ["type" : "didload"])

        setDelegates()
        addVPNServerAnnotations()
        configureUI()
        setup3DMapView()
        setNavigationBar()
        checkSubscriptionState()
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
        
    }
    
    @objc private func willEnterForegroundNotification(_ sender: Notification) {
        // TODO: restore vpn manager state
    }
    
    @objc private func subscriptionStateUpdated (_ notification: Notification) {
        checkSubscriptionState()
    }
    
    private func checkSubscriptionState() {
        let isPremium = SettingsManager.shared.settings?.user.isSubscribed ?? false
        homeView.goProButton.isHidden = isPremium
    }
    
    private func presentSubscriptionPage() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
}

// MARK: - Side Menu
extension HomeViewController {
    private func setSideMenuUI() {
        menuButton = UIButton(type: .system)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium) // Adjust the pointSize and weight as needed
        let menuImage = UIImage(systemName: "list.bullet", withConfiguration: configuration)?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        menuButton!.setImage(menuImage, for: .normal)
        menuButton!.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton!)
        
        sideMenu = SideMenuViewController()
        addChild(sideMenu)
        view.addSubview(sideMenu.view)
        sideMenu.view.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: UIScreen.main.bounds.height)
        sideMenu.didMove(toParent: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMenu(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleSideMenu() {
        isSideMenuOpen.toggle()
        UIView.animate(withDuration: 0.3) {
            if self.isSideMenuOpen {
                self.sideMenu.view.frame.origin.x = 0
            } else {
                self.sideMenu.view.frame.origin.x = -self.sideMenuWidth
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
                // TODO: bura bak
              //  self.selectedServerConfig = response
                
          //      guard let manager = self.tunnelManager else { return }
           //o     manager.connectToWg(config: response)
                
            case .failure(_):
             
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
                    DispatchQueue.main.async {
                      //  self.homeView.setLocationIP(text: response.ipAddress)
                    }
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
        print("STATE CHANGE")
    }
    
    func goProButtonTapped() {
        presentSubscriptionPage()
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
    
    private func zoomOutMap() {
        let worldSpan = MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 120)
        let worldRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: worldSpan)
        homeView.mapView.setRegion(worldRegion, animated: true)
    }
    
    private func setup3DMapView() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0) // Focus on the center of the map
        camera.pitch = 45.0 // Tilt angle in degrees
        camera.altitude = 60000000 // Altitude in meters
        camera.heading = 0 // Camera heading in degrees; north is 0
        
        homeView.mapView.camera = camera
        homeView.mapView.mapType = .satellite
    }
    
    private func setMapRegionToSelectedLocation(server: Server) {
        let coordinate = CLLocationCoordinate2D(latitude: server.location.latitude, longitude: server.location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        homeView.mapView.setRegion(region, animated: true)
        // TODO: connectto selected server
        homeView.setStateLabel(text: "Connect to: \(server.location.city) \n Premium server, \n IP: 212.8.23.23")
    }
}

//MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title, let index = serverList.firstIndex(where: { $0.location.city == title }) {
                homeView.pickerView.selectRow(index, inComponent: 0, animated: true)
                setMapRegionToSelectedLocation(server: serverList[index])
                selectedServer = serverList[index]
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
        let selected = serverList[row]
        selectedServer = selected
        setMapRegionToSelectedLocation(server: selected)
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
