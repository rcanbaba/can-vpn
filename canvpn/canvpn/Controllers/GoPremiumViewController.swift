//
//  GoPremiumViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class GoPremiumViewController: UIViewController {
    
    private lazy var backgroundView = GoPreBackgroundView()
    private lazy var goPreView = GoPremiumView()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.backgroundColor = UIColor.Custom.orange
        configureUI()
        startTimer()
    }
    
    public func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { [weak self] timer in
            self?.processTime()
        })
    }
    
    private func processTime() {
        goPreView.shakeButton()
    }
    
    private func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(goPreView)
        goPreView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
