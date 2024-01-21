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
        view.backgroundColor = UIColor.blue
        
        landingView.delegate = self
        configureUI()
        landingView.setTitle(text: "First")
        landingView.setCenterImage(image: UIImage(named: "landing-img-1"))
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension FirstLandingViewController: LandingMainViewDelegate {
    func nextTapped() {
        delegate?.goNextFromFirst()
    }
}
