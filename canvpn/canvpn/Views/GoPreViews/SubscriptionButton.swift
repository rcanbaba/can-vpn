//
//  SubscriptionButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.03.2023.
//

import UIKit

class SubscriptionButton: UIView {
    
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
    
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.isHidden = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.isHidden = false
        return label
    }()
    
    private lazy var perIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.isHidden = false
        return label
    }()
    
    private lazy var freeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.isHidden = true
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
        
        addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        addSubview(perIntervalLabel)
        perIntervalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(perIntervalLabel.snp.leading).offset(-5)
        }
        
        addSubview(freeLabel)
        freeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
    }
}

extension SubscriptionButton {
    
    public func set(period: String?, price: String?, perInterval: String?) {
        periodLabel.isHidden = false
        priceLabel.isHidden = false
        perIntervalLabel.isHidden = false
        freeLabel.isHidden = true
        
        periodLabel.text = period
        priceLabel.text = price
        perIntervalLabel.text = perInterval
    }
    
    public func setAsFree(text: String?) {
        periodLabel.isHidden = true
        priceLabel.isHidden = true
        perIntervalLabel.isHidden = true
        freeLabel.isHidden = false
        
        backGradientView.gradientLayer.colors = [ UIColor.white, UIColor.white ]
        layer.borderColor = UIColor.Custom.gray.cgColor
        layer.borderWidth = 0.1
        
        freeLabel.text = text
    }
    
}
