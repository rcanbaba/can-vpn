//
//  SubscriptionHistoryViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

class SubscriptionHistoryViewController: UIViewController {
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Custom.premiumBackGradientStart.cgColor,
            UIColor.Custom.premiumBackGradientStart.cgColor,
            UIColor.Custom.premiumBackGradientEnd.cgColor
        ]
        gradientView.isHidden = false
        return gradientView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-gold")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var noContentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private lazy var noContentLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no subscription!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNoContent(isHidden: false)
        
        let titleLabel = UILabel()
        titleLabel.text = "Subscription History"
        titleLabel.textColor = UIColor.Custom.goPreButtonGold
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        navigationItem.titleView = titleLabel
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        setupNoContentView()
    }
    
    private func setupNoContentView() {
        view.addSubview(noContentImageView)
        view.addSubview(noContentLabel)
        
        noContentImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(-100)
            make.width.height.equalTo(80)
        }
        
        noContentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noContentImageView.snp.bottom).offset(10)
            make.leading.greaterThanOrEqualTo(20)
            make.trailing.lessThanOrEqualTo(-20)
        }
    }
    
    private func setNoContent(isHidden: Bool) {
        noContentImageView.isHidden = isHidden
        noContentLabel.isHidden = isHidden
    }
}
