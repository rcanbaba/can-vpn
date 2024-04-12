//
//  FirstLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

protocol FirstLandingDelegate: AnyObject {
    func goNextFromFirst()
}

class FirstLandingViewController: UIViewController {
    
    public weak var delegate: FirstLandingDelegate?
    
    private lazy var landingView = LandingMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landingView.delegate = self
        configureUI()
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

extension FirstLandingViewController: LandingMainViewDelegate {
    func closeTapped() {
        
    }
    
    func termsTapped() {
        
    }
    
    func privacyTapped() {
        
    }
    
    func nextTapped() {
        delegate?.goNextFromFirst()
    }
}
