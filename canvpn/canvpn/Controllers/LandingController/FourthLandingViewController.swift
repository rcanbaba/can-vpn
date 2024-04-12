//
//  FourthLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 11.04.2024.
//

import UIKit

protocol FourthLandingDelegate: AnyObject {
    func goNextFromFourth()
}

class FourthLandingViewController: UIViewController {
    
    public weak var delegate: FourthLandingDelegate?
    
    private lazy var landingView = LandingMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landingView.delegate = self
        configureUI()
        landingView.configureAsOfferView()
        activateCloseButtonTimer()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public func set(data: LandingData) {
        landingView.setStep(image: data.stepImage)
        landingView.setCenterImage(image: data.centerImage)
        landingView.setTitle(text: data.title)
        landingView.setDescription(text: data.description)
        landingView.setButonText(text: data.butonText)
    }
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.landingView.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.landingView.closeButton.alpha = 1
            }
        }
    }
    
    private func showSubscriptionTerms() {
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showPrivacyPage() {
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        guard let url = URL(string: ppDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showCloseAlert() {
        let alertController = UIAlertController(title: "Special Offer", message: "You are about to lose your special offer. Are you sure?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.delegate?.goNextFromFourth()
        }

        let tryNowAction = UIAlertAction(title: "Try Now", style: .default) { (action) in
            self.subscribeInitialOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)

        present(alertController, animated: true)
    }
    
    private func subscribeInitialOffer() {
        //TODO: start subs flow
    }
    
}

extension FourthLandingViewController: LandingMainViewDelegate {
    func closeTapped() {
        showCloseAlert()
    }
    
    func termsTapped() {
        showSubscriptionTerms()
    }
    
    func privacyTapped() {
        showPrivacyPage()
    }
    
    func nextTapped() {
        subscribeInitialOffer()
    }
}
