//
//  ThirdLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

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
        landingView.setTitle(text: "Third")
        landingView.setCenterImage(image: UIImage(named: "landing-img-3"))
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension ThirdLandingViewController: LandingMainViewDelegate {
    func nextTapped() {
        delegate?.goNextFromThird()
    }
}
