//
//  SubscriptionButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.03.2023.
//

import UIKit

class SubscriptionButton: UIButton {
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.gradientLayer.colors = [
            UIColor.Custom.goProButtonGradient1.cgColor,
            UIColor.Custom.goProButtonGradient2.cgColor
        ]
        gradientView.isHidden = false
        return gradientView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.text = "SUBSCRIBE NOW"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 30
        backGradientView.layer.cornerRadius = 30
        backGradientView.clipsToBounds = true
        layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
    }
}
