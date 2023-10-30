//
//  InitialViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.01.2023.
//

import UIKit
import FirebaseAnalytics

class InitialViewController: UIViewController {
    
    private lazy var splashView = SplashScreenView()
    
    private let initialSetupDispatchGroup = DispatchGroup()
    
    private var networkService: DefaultNetworkService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        
        initialSetupDispatchGroup.enter()
        initialSetupDispatchGroup.enter()
        
        splashView.delegate = self

        startInitialSetup()
        
        configureUI()
        initialSetupDispatchGroup.notify(queue: .main) { [weak self] in
            self?.printDebug("dispatchGroup - notify - presentMainScreen")
            self?.checkAvailableUpdatesThenGo()
        }
        Analytics.logEvent("101-InitialScreenPresented", parameters: ["type" : "didload"])
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(splashView)
        splashView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func presentMainScreen(){
        Analytics.logEvent("102-PresentMainScreen", parameters: ["type" : "present"])
        let navigationController = createNavigationController(with: MainScreenViewController())
        navigationController.navigationBar.tintColor = UIColor.clear
        navigationController.navigationBar.backgroundColor = UIColor.clear
        navigationController.navigationBar.barTintColor = UIColor.clear
        present(navigationController, animated:true, completion: nil)
    }
    
    private func goNextScreenAfterUpdate() {
        presentMainScreen()
    }
    
    private func createNavigationController (with viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = UIColor.Custom.orange
        navigationController.navigationBar.backgroundColor = UIColor.Custom.orange
        navigationController.view.backgroundColor = UIColor.Custom.orange
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }
}

// MARK: - AppUpdate
extension InitialViewController {
    
    private func checkAvailableUpdatesThenGo() {
        guard let updateSettings = SettingsManager.shared.settings?.appUpdate else {
            goNextScreenAfterUpdate()
            return
        }
        
        let alert = UIAlertController(title: updateSettings.title, message: updateSettings.message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: updateSettings.confirmText, style: .default) { (action) in
            self.launchUpdateUrl(urlString: updateSettings.updateURL)
        }
        alert.addAction(okAlertAction)
        
        if !updateSettings.isForced {
            let cancelAlertAction = UIAlertAction(title: updateSettings.cancelText, style: .default) { [weak self] (action) in
                self?.goNextScreenAfterUpdate()
            }
            alert.addAction(cancelAlertAction)
        }

        self.present(alert, animated: true)
    }
    
    private func launchUpdateUrl(urlString: String) {
        if let url = URL(string: urlString), urlString != "" {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            goNextScreenAfterUpdate()
        }
    }
    
}


// MARK: Initial Setup
extension InitialViewController {
    
    private func startInitialSetup() {
        if KeyValueStorage.deviceId == nil {
            KeyValueStorage.languageCode = Locale.preferredLocale().languageCode?.lowercased()
            printDebug("try - registerDevice")
            registerDevice()
            registerCreationDate()
        } else {
            printDebug("try - fetchSettings")
            fetchCurrentIP()
            fetchSettings()
        }
    }
    
    private func fetchCurrentIP() {
        guard let service = self.networkService else { return }
        let getIPAddressRequest = GetIPAddressRequest()
        
        service.request(getIPAddressRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.printDebug("getIPAddressRequest success \(response.ipAddress)")
                Constants.originalIP = response.ipAddress
            case .failure(_):
                self.printDebug("getIPAddressRequest failure")
                Analytics.logEvent("009-API-getIPAddressRequest", parameters: ["error" : "happened"])
            }
        }
    }
    
    private func registerCreationDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        let formattedDate = dateFormatter.string(from: currentDate)
        KeyValueStorage.creationDate = formattedDate
    }
    
    private func registerDevice() {
        guard let service = networkService else { return }
        var registerDeviceRequest = RegisterDeviceRequest()
        registerDeviceRequest.setRegisterParams()
        
        service.request(registerDeviceRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                KeyValueStorage.deviceId = response.deviceID
                self.fetchSettings()
                self.printDebug("registerDeviceRequest - success")
                
            case .failure(let error):
                let errorMessage = ErrorHandler.getErrorMessage(for: error)
                if errorMessage == "registerFailed" {
                    self.registerDevice()
                }
                Analytics.logEvent("004-API-registerDeviceRequest", parameters: ["error" : "happened"])
            }
            
        }
    }
    
    
    private func fetchSettings() {
        guard let service = networkService else { return }
        var fetchSettingsRequest = FetchSettingsRequest()
        fetchSettingsRequest.setClientParams()
        
        service.request(fetchSettingsRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                SettingsManager.shared.settings = response
                PurchaseManager.shared.startObserving()
                self.getProductPrices { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.initialSetupDispatchGroup.leave()
                    strongSelf.printDebug("getProductPrices - completed")
                }
                self.printDebug("fetchSettingsRequest - success")
                self.userEntry()
            case .failure(_):
                self.printDebug("fetchSettingsRequest - failure")
                Analytics.logEvent("005-API-fetchSettingsRequest", parameters: ["error" : "happened"])
            }
        }
    }
    
    private func userEntry() {
        guard let service = networkService else { return }
        var userEntryRequest = UserEntryRequest()
        userEntryRequest.setClientParams()
        
        service.request(userEntryRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ): break
            case .failure(let error):
                self.printDebug("userEntryRequest - failure")
                Analytics.logEvent("025-API-userEntryRequest", parameters: ["error" : ErrorHandler.getErrorMessage(for: error)])
            }
        }
    }
    
    private func getProductPrices(completion: @escaping () -> Void) {
        PurchaseManager.shared.getProducts { success, products, error, arg  in
            if success {
                self.printDebug("getProductPrices - completed")
            }
            completion()
        }
    }
    
}

extension InitialViewController: SplashScreenViewDelegate {
    func splashAnimationCompleted() {
        splashView.hideWithAnimation { [weak self] in
            self?.printDebug("splashAnimationCompleted")
            self?.initialSetupDispatchGroup.leave()
        }
    }
    
}
