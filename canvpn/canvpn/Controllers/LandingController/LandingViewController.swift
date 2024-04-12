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
    var fourthViewController: ThirdLandingViewController!
    
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
        fourthViewController = ThirdLandingViewController()
        
        firstViewController.delegate = self
        secondViewController.delegate = self
        thirdViewController.delegate = self
        fourthViewController.delegate = self
    }
    
    private func setPresentations() {
        firstViewController.modalTransitionStyle = .crossDissolve
        secondViewController.modalTransitionStyle = .crossDissolve
        thirdViewController.modalTransitionStyle = .crossDissolve
        fourthViewController.modalTransitionStyle = .crossDissolve
        
        firstViewController.modalPresentationStyle = .overFullScreen
        secondViewController.modalPresentationStyle = .overFullScreen
        thirdViewController.modalPresentationStyle = .overFullScreen
        fourthViewController.modalPresentationStyle = .overFullScreen
    }
    
    private func setData() {
        let firstLandingData = LandingData(
            title: "landing_1_title".localize(),
            description: "landing_1_description".localize(),
            centerImage: UIImage(named: "landing-img-1"),
            stepImage: UIImage(named: "landing-step-1"),
            butonText: "landing_1_button".localize()
        )
        let secondLandingData = LandingData(
            title: "landing_2_title".localize(),
            description: "landing_2_description".localize(),
            centerImage: UIImage(named: "landing-img-2"),
            stepImage: UIImage(named: "landing-step-2"),
            butonText: "landing_2_button".localize()
        )
        let thirdLandingData = LandingData(
            title: "landing_3_title".localize(),
            description: "landing_3_description".localize(),
            centerImage: UIImage(named: "landing-img-3"),
            stepImage: UIImage(named: "landing-step-3"),
            butonText: "landing_3_button".localize()
        )
        let fourthLandingData = LandingData(
            title: "30-Day money back guarantee".localize(),
            description: "Enjoy your premium features with 100% money-back guarantee".localize(),
            centerImage: UIImage(named: "landing-img-4"),
            stepImage: UIImage(named: "landing-step-3"),
            butonText: "Try It Free".localize()
        )
        
        firstViewController.set(data: firstLandingData)
        secondViewController.set(data: secondLandingData)
        thirdViewController.set(data: thirdLandingData)
        fourthViewController.set(data: fourthLandingData)
    }
    
    func startPresentation() {
        present(firstViewController, animated: false)
    }
    
    private func landingTasksCompleted() {
        DispatchQueue.main.async {
            self.dismiss(animated: false) { [weak self] in
                self?.delegate?.landingTasksCompleted()
            }
        }
    }
    
    private func goNext(fromViewController: UIViewController, toViewController: UIViewController) {
        DispatchQueue.main.async {
            fromViewController.dismiss(animated: true) { [weak self] in
                self?.present(toViewController, animated: true)
            }
        }
    }
}

extension LandingViewController: FirstLandingDelegate, SecondLandingDelegate, ThirdLandingDelegate, FourthLandingDelegate {
    func goNextFromFirst() {
        goNext(fromViewController: firstViewController, toViewController: self.secondViewController)
    }
    
    func goNextFromSecond() {
        goNext(fromViewController: secondViewController, toViewController: self.thirdViewController)
    }
    
    func goNextFromThird() {
        if SettingsManager.shared.settings?.isInReview == true {
            landingTasksCompleted()
        } else {
            goNext(fromViewController: thirdViewController, toViewController: self.fourthViewController)
        }

    }
    
    func goNextFromFourth() {
        landingTasksCompleted()
    }
}

struct LandingData {
    var title: String
    var description: String
    var centerImage: UIImage?
    var stepImage: UIImage?
    var butonText: String
}
