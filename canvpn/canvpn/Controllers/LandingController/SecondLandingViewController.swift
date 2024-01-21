//
//  SecondLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

protocol SecondLandingDelegate: AnyObject {
    func goNextFromSecond()
}

class SecondLandingViewController: UIViewController {
    
    public weak var delegate: SecondLandingDelegate?
    
    private lazy var landingView = LandingMainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landingView.delegate = self
        configureUI()
        landingView.setTitle(text: "Second")
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SecondLandingViewController: LandingMainViewDelegate {
    func nextTapped() {
        delegate?.goNextFromSecond()
    }
}
