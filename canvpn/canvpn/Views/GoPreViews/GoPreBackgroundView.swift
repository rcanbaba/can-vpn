//
//  GoPreBackgroundView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class GoPreBackgroundView: GradientView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-bg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.colors = [
            UIColor.Custom.orange.cgColor,
            UIColor.Custom.goPreGradient1.cgColor,
            UIColor.Custom.goPreGradient1.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(160)
            make.leading.trailing.equalToSuperview()
        }
        
        backgroundImageView.alpha = 0.1
    }
    
}

