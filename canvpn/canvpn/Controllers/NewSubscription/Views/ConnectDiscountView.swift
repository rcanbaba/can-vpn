//
//  ConnectDiscountView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit

class ConnectDiscountView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    public lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "50% Save".localize()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupGradientLayer()
        
        // Define which corners should be rounded
        let roundedCorners: UIRectCorner = [.topLeft, .bottomRight]
        roundCorners(corners: roundedCorners, radius: 10)
        
        addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.NewSubs.green.cgColor,
            UIColor.NewSubs.gradierGreen.cgColor
        ]
        
        gradientLayer.type = .radial
        
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        roundCorners(corners: [.topLeft, .bottomRight], radius: 10)
    }
}

extension ConnectDiscountView {
    public func setOrangeUI() {
        gradientLayer.colors = [
            UIColor.NewSubs.orange.cgColor,
            UIColor.NewSubs.redder.cgColor
        ]
    }
}
