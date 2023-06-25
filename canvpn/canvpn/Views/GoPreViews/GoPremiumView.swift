//
//  GoPremiumView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

protocol PremiumViewDelegate: AnyObject {
    func subscribeSelected(indexOf: Int)
    func subscriptionTermsTapped()
    func subscriptionRestoreTapped()
}

class GoPremiumView: UIView {
    
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
    
    private lazy var firstOffer: OfferButton = {
        let view = OfferButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstOfferTapped(_:))))
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var secondOffer: OfferButton = {
        let view = OfferButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondOfferTapped(_:))))
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var thirdOffer: OfferButton = {
        let view = OfferButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thirdOfferTapped(_:))))
        view.layer.applySketchShadow()
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private var isFirstOfferSelected: Bool = false
    private var isSecondOfferSelected: Bool = false
    private var isThirdOfferSelected: Bool = false
    
    private lazy var topView = PremiumTopView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureFeaturesStack()
        setProducts()
        selectFirstOffer()
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
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        addSubview(featuresMainStackView)
        featuresMainStackView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(34)
            make.trailing.equalToSuperview().inset(30)
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(20)
        }
        
        addSubview(firstOffer)
        firstOffer.snp.makeConstraints { make in
            make.top.equalTo(featuresMainStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        addSubview(secondOffer)
        secondOffer.snp.makeConstraints { make in
            make.top.equalTo(firstOffer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        addSubview(thirdOffer)
        thirdOffer.snp.makeConstraints { make in
            make.top.equalTo(secondOffer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
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

// MARK: - OFFER SELECTION
extension GoPremiumView {
    
    private func selectFirstOffer() {
        isFirstOfferSelected = true
        isSecondOfferSelected = false
        isThirdOfferSelected = false
        setSelectionToOffer()
    }
    
    private func selectSecondOffer() {
        isFirstOfferSelected = false
        isSecondOfferSelected = true
        isThirdOfferSelected = false
        setSelectionToOffer()
    }
    
    private func selectThirdOffer() {
        isFirstOfferSelected = false
        isSecondOfferSelected = false
        isThirdOfferSelected = true
        setSelectionToOffer()
    }
    
    private func setSelectionToOffer() {
        firstOffer.isSelected = isFirstOfferSelected
        secondOffer.isSelected = isSecondOfferSelected
        thirdOffer.isSelected = isThirdOfferSelected
    }
}


// MARK: - ACTIONS
extension GoPremiumView {
    @objc private func firstOfferTapped (_ sender: UITapGestureRecognizer) {
        selectFirstOffer()
    }
    
    @objc private func secondOfferTapped (_ sender: UITapGestureRecognizer) {
        selectSecondOffer()
    }
    
    @objc private func thirdOfferTapped (_ sender: UITapGestureRecognizer) {
        selectThirdOffer()
    }
    
    @objc private func subscribeTapped (_ sender: UITapGestureRecognizer) {
        delegate?.subscribeSelected(indexOf: getSelectedOneIndex())
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.subscriptionTermsTapped()
    }
    
    @objc func restoreLabelTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.subscriptionRestoreTapped()
    }
}

fileprivate extension GoPremiumView {
    private func getSelectedOneIndex() -> Int {
        if isFirstOfferSelected {
            return 0
        } else if isSecondOfferSelected {
            return 1
        } else if isThirdOfferSelected {
            return 2
        } else {
            return 0
        }
    }
}


// MARK: - PUBLIC METHODS
extension GoPremiumView {
    public func setProducts() {
        firstOffer.set(period: "1 Week", price: "4.99", perInterval: "$/Week")
        secondOffer.set(period: "1 Month", price: "9.99", perInterval: "$/Month")
        thirdOffer.set(period: "1 Year", price: "4.99", perInterval: "$/Month")
    }
    
    public func isLoading(show: Bool) {
        self.isUserInteractionEnabled = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
