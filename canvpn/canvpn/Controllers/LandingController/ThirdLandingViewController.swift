//
//  ThirdLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit
import FirebaseAnalytics
import StoreKit

protocol ThirdLandingDelegate: AnyObject {
    func goNextFromThird()
}

class ThirdLandingViewController: UIViewController {
    
    public weak var delegate: ThirdLandingDelegate?
    
    private lazy var landingView = LandingMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landingView.delegate = self
        configureUI()
        presentRating()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public func set(data: LandingData) {
        landingView.remakeAsRatingPage()
        landingView.setStep(image: data.stepImage)
        landingView.setCenterImage(image: data.centerImage)
        landingView.setTitle(text: data.title)
        landingView.setDescription(text: data.description)
        landingView.setButonText(text: data.butonText)
    }
    
    private func presentRating() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
}

extension ThirdLandingViewController: LandingMainViewDelegate {
    func closeTapped() {
        
    }
    
    func termsTapped() {
        
    }
    
    func privacyTapped() {
        
    }
    
    func nextTapped() {
        delegate?.goNextFromThird()
    }
}
