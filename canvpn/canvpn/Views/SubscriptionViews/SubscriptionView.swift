//
//  SubscriptionView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

protocol PremiumViewDelegate: AnyObject {
    func subscribeTapped()
    func subscriptionTermsTapped()
    func subscriptionRestoreTapped()
    func tryCouponCodeTapped()
}

class SubscriptionView: UIView {
    
    public weak var delegate: PremiumViewDelegate?
    
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
    
    public lazy var offerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: "OfferTableViewCell")
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        return tableView
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
    
    public lazy var featuresTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeaturesTableViewCell.self, forCellReuseIdentifier: "FeaturesTableViewCell")
        tableView.rowHeight = 38
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = true
        tableView.layer.cornerRadius = 12
        tableView.layer.applySubscriptionShadow()
        tableView.layer.masksToBounds = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Get Premium1".localize()
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
    
// MARK: - Setup UI
    private func configureUI() {
        addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        addSubview(featuresTableView)
        featuresTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        featuresTableView.layer.applySubscriptionShadow()
        featuresTableView.layer.masksToBounds = false

        addSubview(subscribeButton)
        subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(subscribeButton.snp.bottom).offset(13)
        }
        
        addSubview(restoreLabel)
        restoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(subscribeButton.snp.bottom).offset(13)
        }
        
        addSubview(couponLabel)
        couponLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subscribeButton.snp.top).offset(-13)
        }
        
        addSubview(offerTableView)
        offerTableView.snp.makeConstraints { make in
            make.top.equalTo(featuresTableView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(subscribeButton.snp.top).offset(-32)
        }

        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
}

// MARK: - ACTIONS
extension SubscriptionView {
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

// MARK: - PUBLIC METHODS
extension SubscriptionView {
    public func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    public func setCouponLabel(isHidden: Bool) {
        couponLabel.isHidden = isHidden
    }
}
