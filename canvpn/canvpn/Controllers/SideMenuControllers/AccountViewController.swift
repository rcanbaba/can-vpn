//
//  AccountViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

class AccountViewController: UIViewController {
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let ipAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "IP Address: 192.168.1.1" // Set your dynamic IP Address here
        label.textColor = UIColor.Custom.goPreGrayText
        return label
    }()
    
    private let deviceModelLabel: UILabel = {
        let label = UILabel()
        label.text = "Device Model: \(UIDevice.current.model)"
        label.textColor = UIColor.Custom.goPreGrayText
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Creation Date: \(Date())" // Set your user's creation date here
        label.textColor = UIColor.Custom.goPreGrayText
        return label
    }()
    
    private let subscriptionTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscription: Free", for: .normal)
        button.setTitleColor(UIColor.Custom.goPreGrayText, for: .normal)
        // Add your subscription plan presentation logic here
        button.addTarget(self, action: #selector(presentSubscriptionPlan), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        // Set the navigation title
        navigationItem.title = "About Us"
        navigationItem.titleView?.tintColor = .black
        
        // Adding subviews
        view.addSubview(topLogoImageView)
        view.addSubview(ipAddressLabel)
        view.addSubview(deviceModelLabel)
        view.addSubview(creationDateLabel)
        view.addSubview(subscriptionTypeButton)
        
        // Setting up constraints using SnapKit
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(100) // Adjust as per your logo's requirement
        }
        
        ipAddressLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(20)
        }
        
        deviceModelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ipAddressLabel.snp.bottom).offset(10)
        }
        
        creationDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(deviceModelLabel.snp.bottom).offset(10)
        }
        
        subscriptionTypeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(creationDateLabel.snp.bottom).offset(20)
        }
        
    }
    
    @objc func presentSubscriptionPlan() {
        // Implement your subscription plan presentation logic here
    }
}
