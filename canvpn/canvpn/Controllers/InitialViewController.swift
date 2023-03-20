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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Custom.orange
        view.addSubview(splashView)
        splashView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        splashView.delegate = self
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

extension InitialViewController: SplashScreenViewDelegate {
    func splashAnimationCompleted() {
        splashView.hideWithAnimation { [weak self] in
            self?.splashView.removeFromSuperview()
            self?.presentMainScreen()
        }
    }
    
}
