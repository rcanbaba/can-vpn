//
//  OfferButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.06.2023.
//

import UIKit

class OfferButton: UIView {
    
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var perIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .left
        return label
    }()
    
    
    public var isSelected: Bool = false {
        didSet {
            isSelected ? configureAsSelected() : configureAsNotSelected()
        }
    }

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
        backgroundColor = .white
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.Custom.offerButtonBorderGray.cgColor

        layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)

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
        
    }
    
    private func configureAsSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layer.borderColor = UIColor.Custom.offerButtonBorderOrange.cgColor
        }
        periodLabel.textColor = UIColor.Custom.offerButtonTextOrange
        perIntervalLabel.textColor = UIColor.Custom.offerButtonTextOrange
        priceLabel.textColor = UIColor.Custom.offerButtonTextOrange
    }
    
    private func configureAsNotSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layer.borderColor = UIColor.Custom.offerButtonBorderGray.cgColor
        }
        periodLabel.textColor = UIColor.Custom.offerButtonTextGray
        perIntervalLabel.textColor = UIColor.Custom.offerButtonTextGray
        priceLabel.textColor = UIColor.Custom.offerButtonTextGray
    }
    
}

extension OfferButton {
    public func set(period: String?, price: String?, perInterval: String?) {
        periodLabel.text = period
        priceLabel.text = price
        perIntervalLabel.text = perInterval
    }
    
}

