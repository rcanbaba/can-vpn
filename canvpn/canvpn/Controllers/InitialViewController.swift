//
//  InitialViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.01.2023.
//

import UIKit
import Lottie
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
            self?.presentMainScreen()
        }
        Analytics.logEvent("101-InitialScreenPresented", parameters: ["type" : "didload"])
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.Custom.orange
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
    
    private func createNavigationController (with viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = UIColor.Custom.orange
        navigationController.navigationBar.backgroundColor = UIColor.Custom.orange
        navigationController.view.backgroundColor = UIColor.Custom.orange
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }
}

// MARK: Initial Setup
extension InitialViewController {
    
    private func startInitialSetup() {
        if KeyValueStorage.deviceId == nil {
            printDebug("try - registerDevice")
            registerDevice()
        } else {
            printDebug("try - fetchSettings")
            fetchSettings()
        }
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
                self.printDebug("registerDeviceRequest - failure")
                // TODO
                // bi daha register dene hataya göre çözüm
                // registerDevice()
                Analytics.logEvent("004-API-registerDeviceRequest", parameters: ["error" : error.localizedDescription])
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
                self.initialSetupDispatchGroup.leave()
                self.printDebug("fetchSettingsRequest - success")
                
            case .failure(let error):
                self.printDebug("fetchSettingsRequest - failure")
                Analytics.logEvent("005-API-fetchSettingsRequest", parameters: ["error" : error.localizedDescription])
            }
            
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
