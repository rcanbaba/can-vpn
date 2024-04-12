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
    
}

extension FourthLandingViewController: LandingMainViewDelegate {
    func closeTapped() {
        
    }
    
    func termsTapped() {
        
    }
    
    func privacyTapped() {
        
    }
    
    func nextTapped() {
        delegate?.goNextFromFourth()
    }
}
