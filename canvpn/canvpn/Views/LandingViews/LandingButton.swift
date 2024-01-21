//
//  LandingButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.01.2024.
//

import UIKit

class LandingButton: UIButton {
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.gradientLayer.colors = [
            UIColor.Landing.buttonGradientStart.cgColor,
            UIColor.Landing.buttonGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Continue".localize()
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
        layer.cornerRadius = 24
        backGradientView.layer.cornerRadius = 24
        backGradientView.clipsToBounds = true
        
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
