//
//  SubscriptionOverlayView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 27.01.2024.
//

import UIKit

protocol SubscriptionOverlayViewDelegate: AnyObject {
    func subscribeTapped()
    func subscriptionTermsTapped()
    func subscriptionRestoreTapped()
    func tryCouponCodeTapped()
}

class SubscriptionOverlayView: UIView {
    
    public weak var delegate: SubscriptionOverlayViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .natural
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6.0
        return stackView
    }()

    private lazy var subscribeButton: SubscriptionButton = {
        let view = SubscriptionButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(subscribeTapped(_:))))
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var termsLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.goProFeatureTextGray
        label.textAlignment = .left
        label.text = "subs_terms_key".localize()
        return label
    }()
    
    private lazy var restoreLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.goProFeatureTextGray
        label.textAlignment = .right
        label.text = "subs_restore_key".localize()
        return label
    }()
    
    private lazy var couponLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.goProFeatureTextGray
        label.textAlignment = .right
        label.text = "try_coupon_code_key".localize()
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        baseView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        
        baseView.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let restoreTapGesture = UITapGestureRecognizer(target: self, action: #selector(restoreLabelTapped(_:)))
        restoreLabel.addGestureRecognizer(restoreTapGesture)
        restoreLabel.isUserInteractionEnabled = true
        
        let couponTapGesture = UITapGestureRecognizer(target: self, action: #selector(couponLabelTapped(_:)))
        couponLabel.addGestureRecognizer(couponTapGesture)
        couponLabel.isUserInteractionEnabled = true
    }
    
    @objc private func subscribeTapped (_ sender: UITapGestureRecognizer) {
        delegate?.subscribeTapped()
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.subscriptionTermsTapped()
    }
    
    @objc func restoreLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.subscriptionRestoreTapped()
    }
    
    @objc func couponLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.tryCouponCodeTapped()
    }
    
}


