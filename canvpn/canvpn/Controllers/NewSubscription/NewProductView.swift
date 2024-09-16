//
//  NewProductView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit

class NewProductView: UIView {
    
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
    
    private lazy var productNameLabel: UILabel = {
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
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .right
        label.text = "$0.99".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var oldPriceLabel: StrikethroughLabel = {
        let label = StrikethroughLabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.NewSubs.oldGray
        label.textAlignment = .right
        label.text = "$1.99".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var discountView: ConnectDiscountView = {
        let view = ConnectDiscountView()
        return view
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
        
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(13)
        }
        
        addSubview(newPriceLabel)
        newPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(productNameLabel.snp.centerY)
        }
        
        addSubview(oldPriceLabel)
        oldPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(newPriceLabel.snp.top).inset(-7)
        }
        
        addSubview(discountView)
        discountView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(28.5)
        }
        
    }
    
}

// MARK: - Public methods
extension NewProductView {
    public func set(productNameText: String) {
        productNameLabel.text = productNameText
    }
    
    public func set(newPriceText: String) {
        newPriceLabel.text = newPriceText
    }
    
    public func set(oldPriceText: String) {
        oldPriceLabel.text = oldPriceText
    }
    
    public func set(discountText: String) {
        discountView.discountLabel.text = discountText
    }
    
    public func setGreenUI() {
        backgroundColor = UIColor.NewSubs.green.withAlphaComponent(0.15)
        layer.borderColor = UIColor.NewSubs.green.cgColor
        
    }
    
    public func setOrangeUI() {
        backgroundColor = UIColor.NewSubs.oranger.withAlphaComponent(0.15)
        layer.borderColor = UIColor.NewSubs.oranger.cgColor
        
    }
    
}
