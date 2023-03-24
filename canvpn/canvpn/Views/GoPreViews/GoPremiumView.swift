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
    
    private lazy var freeTrialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Start 3 days free trial then"
        return label
    }()
    
    private lazy var subscriptionBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.white
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var firstProductView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.Custom.orange
        view.layer.applySketchShadow()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstProductTapped(_:))))
        return view
    }()
    
    private lazy var secondProductView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.Custom.orange
        view.layer.applySketchShadow()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondProductTapped(_:))))
        return view
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.Text.white, for: .normal)
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor.Custom.orange
        button.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.layer.applySketchShadow()
        return button
    }()
    
    private lazy var featuresMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10.0
        return stackView
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
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
//
//        addSubview(subscribeButton)
//        subscribeButton.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview().inset(100)
//            make.height.equalTo(50)
//            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
//        }
//
//        addSubview(freeTrialLabel)
//        freeTrialLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(subscriptionBackView.snp.top).inset(-60)
//        }
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
    
    @objc private func subscribeButtonTapped(_ sender: UIButton) {
        subscribeButton.shake()
    }
    
    @objc private func firstProductTapped (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.firstProductView.alpha = 1.0
            self.firstProductView.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            self.firstProductView.transform = CGAffineTransform(translationX: 10, y: -20)
           
        }
    }
    
    @objc private func secondProductTapped (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.secondProductView.alpha = 1.0
            self.secondProductView.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            self.secondProductView.transform = CGAffineTransform(translationX: 10, y: -20)
            self.firstProductView.transform = CGAffineTransform(scaleX: 0.9, y: 0.8)
            self.firstProductView.transform = CGAffineTransform(translationX: -10, y: 20)
        }
    }
    
    public func shakeButton() {
        subscribeButton.shake()
    }
    
}
