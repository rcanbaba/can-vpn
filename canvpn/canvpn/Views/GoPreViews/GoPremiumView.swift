//
//  GoPremiumView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class GoPremiumView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "world-map-gold")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "go-pro-image")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Premium Features"
        return label
    }()
    
    private lazy var featuresMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var firstSubscriptionButton: SubscriptionButton = {
        let view = SubscriptionButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstProductTapped(_:))))
        view.set(period: "1 MONTH", price: "9.99", perInterval: "$/Month")
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var secondSubscriptionButton: SubscriptionButton = {
        let view = SubscriptionButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondProductTapped(_:))))
        view.set(period: "1 YEAR", price: "4.99", perInterval: "$/Month")
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var freeSubscriptionButton: SubscriptionButton = {
        let view = SubscriptionButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(freeProductTapped(_:))))
        view.setAsFree(text: "TRY PREMIUM FREE")
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var freeTrialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.goProFeatureTextGray
        label.textAlignment = .center
        label.text = "7-day free trial. Then 9.99 $/month"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureFeaturesStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        
        addSubview(backgroundImageView)
        
        addSubview(premiumImageView)
        premiumImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.width.equalTo(72)
            make.height.equalTo(74)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumImageView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        
        addSubview(featuresMainStackView)
        featuresMainStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        addSubview(firstSubscriptionButton)
        firstSubscriptionButton.snp.makeConstraints { make in
            make.top.equalTo(featuresMainStackView.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        addSubview(secondSubscriptionButton)
        secondSubscriptionButton.snp.makeConstraints { make in
            make.top.equalTo(firstSubscriptionButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        addSubview(freeSubscriptionButton)
        freeSubscriptionButton.snp.makeConstraints { make in
            make.top.equalTo(secondSubscriptionButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        addSubview(freeTrialLabel)
        freeTrialLabel.snp.makeConstraints { make in
            make.top.equalTo(freeSubscriptionButton.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(36)
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
    
    @objc private func firstProductTapped (_ sender: UITapGestureRecognizer) {

    }
    
    @objc private func secondProductTapped (_ sender: UITapGestureRecognizer) {

    }
    
    @objc private func freeProductTapped (_ sender: UITapGestureRecognizer) {

    }

}
