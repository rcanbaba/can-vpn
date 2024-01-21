//
//  LandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

protocol LandingViewControllerDelegate: AnyObject {
    func landingTasksCompleted()
}

class LandingViewController: UIViewController {
    
    public weak var delegate: LandingViewControllerDelegate?

    var firstViewController: FirstLandingViewController!
    var secondViewController: SecondLandingViewController!
    var thirdViewController: ThirdLandingViewController!
    
    private lazy var landingBaseView = LandingBackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setControllers()
        setPresentations()
        setData()
        startPresentation()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingBaseView)
        landingBaseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setControllers() {
        firstViewController = FirstLandingViewController()
        secondViewController = SecondLandingViewController()
        thirdViewController = ThirdLandingViewController()
        
        firstViewController.delegate = self
        secondViewController.delegate = self
        thirdViewController.delegate = self
    }
    
    private func setPresentations() {
        firstViewController.modalTransitionStyle = .crossDissolve
        secondViewController.modalTransitionStyle = .crossDissolve
        thirdViewController.modalTransitionStyle = .crossDissolve
        
        firstViewController.modalPresentationStyle = .overFullScreen
        secondViewController.modalPresentationStyle = .overFullScreen
        thirdViewController.modalPresentationStyle = .overFullScreen
    }
    
    private func setData() {
        let firstLandingData = LandingData(
            title: "Secure Your Appearance",
            description: "You can make secure your internet connection via vpn.",
            centerImage: UIImage(named: "landing-img-1"),
            stepImage: UIImage(named: "landing-step-1"),
            butonText: "Continue".localize()
        )
        let secondLandingData = LandingData(
            title: "Access Faster Internet",
            description: "Wireguard Kit supported tunnel configuration you could reach faster connection.",
            centerImage: UIImage(named: "landing-img-2"),
            stepImage: UIImage(named: "landing-step-2"),
            butonText: "Continue".localize()
        )
        let thirdLandingData = LandingData(
            title: "More Than 100 Location",
            description: "You reach different locations around the world! ",
            centerImage: UIImage(named: "landing-img-3"),
            stepImage: UIImage(named: "landing-step-3"),
            butonText: "Get Started".localize()
        )
        
        firstViewController.set(data: firstLandingData)
        secondViewController.set(data: secondLandingData)
        thirdViewController.set(data: thirdLandingData)
    }
    
    func startPresentation() {
        present(firstViewController, animated: false)
    }
}

extension LandingViewController: FirstLandingDelegate, SecondLandingDelegate, ThirdLandingDelegate {
    func goNextFromFirst() {
        firstViewController.dismiss(animated: true) {
            self.present(self.secondViewController, animated: true)
        }
    }
    
    func goNextFromSecond() {
        secondViewController.dismiss(animated: true) {
            self.present(self.thirdViewController, animated: true)
        }
    }
    
    func goNextFromThird() {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.landingTasksCompleted()
        }
    }
    
}

struct LandingData {
    var title: String
    var description: String
    var centerImage: UIImage?
    var stepImage: UIImage?
    var butonText: String
}
