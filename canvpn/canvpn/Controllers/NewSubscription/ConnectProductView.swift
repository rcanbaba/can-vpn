//
//  ConnectProductView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit

class ConnectProductView: UIView {
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Landing.backGradientStart.cgColor,
            UIColor.Landing.backGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .left
        label.text = "Weekly".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .left
        label.text = "Weekly".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.NewSubs.oldGray
        label.textAlignment = .left
        label.text = "Weekly".localize()
        label.numberOfLines = 0
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
        backgroundColor = UIColor.NewSubs.green.withAlphaComponent(0.15)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.NewSubs.green.cgColor
        layer.cornerRadius = 10.0
        
        addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
