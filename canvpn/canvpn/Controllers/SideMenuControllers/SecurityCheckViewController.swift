//
//  SecurityCheckViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit
import Lottie

class SecurityCheckViewController: UIViewController {
    
    private lazy var topLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-logo-orange")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Custom.orange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Your network is being threatened!"
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
        animation.loopMode = .playOnce
        animation.contentMode = .scaleAspectFill
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = view.center
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY)
        }
        
        animationView.play() {_ in
            self.configureUI()
        }
        
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
            ("exclamationmark.triangle.fill", "Hacker attacks")
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
    }
}
