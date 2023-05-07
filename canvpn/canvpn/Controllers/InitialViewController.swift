//
//  InitialViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.01.2023.
//

import UIKit
import Lottie

class InitialViewController: UIViewController {
    
    private lazy var splashView = SplashScreenView()
    
    private var networkService: DefaultNetworkService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        view.backgroundColor = UIColor.Custom.orange
        view.addSubview(splashView)
        splashView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        splashView.delegate = self

        startInitialSetup()
    }
    
    private func presentMainScreen(){
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
            registerDevice()
        } else {
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
                print("CAN denemeReq success")
                
            case .failure(let error):
                print("CAN denemeReq failed")
                // TODO
                // bi daha register dene hataya göre çözüm
                // registerDevice()
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

                print("CAN settings success")
                
            case .failure(let error):
                print("CAN settings failed")

            }
            
        }
        
    }
    
    
}

// TODO: animation counter da sayalım
extension InitialViewController: SplashScreenViewDelegate {
    func splashAnimationCompleted() {
        splashView.hideWithAnimation { [weak self] in
            self?.splashView.removeFromSuperview()
        //    self?.presentMainScreen()
        }
    }
    
}
