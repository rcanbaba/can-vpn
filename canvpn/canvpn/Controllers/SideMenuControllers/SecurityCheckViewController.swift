//
//  SecurityCheckViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import Lottie
import NetworkExtension

class SecurityCheckViewController: UIViewController {
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "checking-animation")
        animation.loopMode = .repeat(Float(2))
        animation.contentMode = .scaleAspectFill
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChecking()
        setMainStackView(alpha: 0.0)
        configureUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.animationView.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.checkIsSecure()
            }
        }
    }
    
    private func checkIsSecure() {
        let tunnelManager = NETunnelManager()
        tunnelManager.delegate = self
    }
    
    private func setChecking() {
        mainLabel.text = "Checking..."
        topLogoImageView.image = UIImage(named: "top-logo-gray")
        self.mainLabel.textColor = UIColor.Custom.gray
    }
    
    private func setSecure() {
        DispatchQueue.main.async {
            self.mainLabel.text = "Your network is secure!"
            self.topLogoImageView.image = UIImage(named: "top-logo-green")
            self.mainLabel.textColor = UIColor.Custom.green
        }
    }
    
    private func setNotSecure() {
        DispatchQueue.main.async {
            self.mainLabel.text = "Your network is being threatened!"
            self.topLogoImageView.image = UIImage(named: "top-logo-orange")
            self.mainLabel.textColor = UIColor.Custom.orange
            UIView.animate(withDuration: 0.2, delay: 0.2) { [weak self] in
                self?.setMainStackView(alpha: 1.0)
            }
        }
    }
    
    private func setMainStackView(alpha: CGFloat) {
        mainStackView.alpha = alpha
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(topLogoImageView)
        view.addSubview(mainLabel)
        view.addSubview(mainStackView)
        
        topLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.width.height.equalTo(100)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLogoImageView.snp.bottom).offset(48)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(24)
        }

        let warnings = [
            ("exclamationmark.triangle.fill", "Your IP address: \(Constants.originalIP)"),
            ("exclamationmark.triangle.fill", "Network activities may be being tracked"),
            ("exclamationmark.triangle.fill", "Not encrypted tunnel"),
            ("exclamationmark.triangle.fill", "Hacker attacks"),
        ]
        
        for warning in warnings {
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(systemName: warning.0)
            iconImageView.tintColor = UIColor.Custom.orange
            iconImageView.contentMode = .scaleAspectFit

            let textLabel = UILabel()
            textLabel.text = warning.1
            textLabel.textColor = UIColor.Custom.gray

            let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, textLabel])
            horizontalStackView.spacing = 12
            horizontalStackView.alignment = .center

            mainStackView.addArrangedSubview(horizontalStackView)
        }
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY)
        }
        
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = view.center
    }
}

extension SecurityCheckViewController: NETunnelManagerDelegate {
    func stateChanged(state: NEVPNStatus) {
        state == .connected ? setSecure() : setNotSecure()
    }
}
