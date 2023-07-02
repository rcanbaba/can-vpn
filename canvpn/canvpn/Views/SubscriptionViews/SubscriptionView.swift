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
}

class SubscriptionView: UIView {
    
    public weak var delegate: PremiumViewDelegate?
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Custom.premiumBackGradientStart.cgColor,
            UIColor.Custom.premiumBackGradientStart.cgColor,
            UIColor.Custom.premiumBackGradientEnd.cgColor
        ]
        gradientView.isHidden = false
        return gradientView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-gold")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var featuresMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10.0
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var topView = PremiumTopView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureFeaturesStack()
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
        
        addSubview(backgroundImageView)
        
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        addSubview(featuresMainStackView)
        featuresMainStackView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(34)
            make.trailing.equalToSuperview().inset(30)
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(20)
        }

        addSubview(subscribeButton)
        subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(subscribeButton.snp.bottom).offset(16)
        }
        
        addSubview(restoreLabel)
        restoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(subscribeButton.snp.bottom).offset(16)
        }
        
        addSubview(offerTableView)
        offerTableView.snp.makeConstraints { make in
            make.top.equalTo(featuresMainStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(subscribeButton.snp.top).offset(-30)
        }

        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureFeaturesStack() {
        
        let firstRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.alignment = .center
        firstRowStackView.spacing = 10.0
        
        let secondRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.alignment = .center
        firstRowStackView.spacing = 10.0
        
        featuresMainStackView.addArrangedSubview(firstRowStackView)
        featuresMainStackView.addArrangedSubview(secondRowStackView)
        
        var featureViewArray: [PremiumFeatureView] = []
        
        for _ in 0..<4 {
            featureViewArray.append(PremiumFeatureView())
        }
        
        featureViewArray[0].set(type: .secure)
        featureViewArray[1].set(type: .fast)
        featureViewArray[2].set(type: .noAds)
        featureViewArray[3].set(type: .anonymous)
                
        firstRowStackView.addArrangedSubview(featureViewArray[0])
        firstRowStackView.addArrangedSubview(featureViewArray[1])
        
        secondRowStackView.addArrangedSubview(featureViewArray[2])
        secondRowStackView.addArrangedSubview(featureViewArray[3])
        
        let featureItemWidth = (UIScreen.main.bounds.width - 70 - 10) / 2
        
        for item in featureViewArray {
            item.snp.makeConstraints { make in
                make.width.equalTo(featureItemWidth)
            }
        }
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let restoreTapGesture = UITapGestureRecognizer(target: self, action: #selector(restoreLabelTapped(_:)))
        restoreLabel.addGestureRecognizer(restoreTapGesture)
        restoreLabel.isUserInteractionEnabled = true
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
}

// MARK: - PUBLIC METHODS
extension SubscriptionView {
    public func isLoading(show: Bool) {
        self.isUserInteractionEnabled = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
