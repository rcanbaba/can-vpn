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
        imageView.image = UIImage(named: "top-logo-green")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var ipAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Custom.goPreGrayText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var deviceModelLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Custom.goPreGrayText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var creationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Custom.goPreGrayText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var tosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms of Service", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.Custom.goPreGrayText, for: .normal)
        button.addTarget(self, action: #selector(presentTos), for: .touchUpInside)
        return button
    }()
    
    private lazy var ppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy & Policy", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.Custom.goPreGrayText, for: .normal)
        button.addTarget(self, action: #selector(presentPp), for: .touchUpInside)
        return button
    }()
    
    private lazy var subscriptionTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Account Subscription: Free", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.Custom.goPreGrayText, for: .normal)
        button.addTarget(self, action: #selector(presentSubscriptionPlan), for: .touchUpInside)
        return button
    }()
    
    private lazy var goProButton: GoProButton = {
        let button = GoProButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goProButtonTapped(_:))))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkSubscriptionState()
        setCreationDateText()
        setDeviceModelText()
        setIpAddressText()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.titleView?.tintColor = .black
        
        view.addSubview(topLogoImageView)
        view.addSubview(ipAddressLabel)
        view.addSubview(deviceModelLabel)
        view.addSubview(creationDateLabel)
        view.addSubview(tosButton)
        view.addSubview(ppButton)
        view.addSubview(subscriptionTypeButton)
        view.addSubview(goProButton)
        
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.width.height.equalTo(100)
        }
        
        ipAddressLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(48)
        }
        
        deviceModelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ipAddressLabel.snp.bottom).offset(16)
        }
        
        creationDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(deviceModelLabel.snp.bottom).offset(16)
        }
        
        tosButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(creationDateLabel.snp.bottom).offset(24)
        }
        
        ppButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tosButton.snp.bottom).offset(16)
        }
        
        subscriptionTypeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ppButton.snp.bottom).offset(16)
        }
        
        goProButton.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
    }
    
    @objc private func goProButtonTapped (_ sender: UIControl) {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
    @objc func presentTos() {
        let tosDefaultUrl = SettingsManager.shared.settings?.links.termsURL ?? Constants.appTermsOfServicePageURLString
        guard let url = URL(string: tosDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func presentPp() {
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        guard let url = URL(string: ppDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func presentSubscriptionPlan() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
    private func checkSubscriptionState() {
        let isPremium = SettingsManager.shared.settings?.user.isSubscribed ?? false
        goProButton.setState(isPremium: isPremium)
        setSubscriptionButtonText(isPremium: isPremium)
    }
    
    private func setSubscriptionButtonText(isPremium: Bool) {
        let text = isPremium ? "Premium" : "Free"
        subscriptionTypeButton.setTitle("Account Subscription: \(text)", for: .normal)
    }
    
    private func setCreationDateText() {
        creationDateLabel.text = "Account Creation Date: \(KeyValueStorage.creationDate)"
    }
    
    private func setDeviceModelText() {
        deviceModelLabel.text = "Device Model: \(UIDevice.current.modelName)"
    }
    
    private func setIpAddressText() {
        ipAddressLabel.text = "Original IP Address: \(Constants.originalIP)"
    }
}
