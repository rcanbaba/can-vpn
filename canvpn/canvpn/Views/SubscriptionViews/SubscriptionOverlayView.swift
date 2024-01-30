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
    func productSelected(id: String?)
}

class SubscriptionOverlayView: UIView {
    
    public weak var delegate: SubscriptionOverlayViewDelegate?

    private lazy var presentedProductViewArray: [ProductItemView] = []
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Subscription.overlayBackGradientStart.cgColor,
            UIColor.Subscription.overlayBackGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .natural
        label.text = "Choose your plan"
        return label
    }()

    private lazy var productStackView: UIStackView = {
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
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .center
        label.text = "subs_terms_key".localize()
        return label
    }()
    
    private lazy var restoreLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .right
        label.text = "subs_restore_key".localize()
        return label
    }()
    
    private lazy var couponLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
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
        backgroundColor = .white
        
        addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(productStackView)
        productStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(subscribeButton)
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(productStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(70)
        }
        
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(subscribeButton.snp.bottom).offset(10)
        }
        
        addSubview(restoreLabel)
        restoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(termsLabel.snp.bottom).offset(16)
        }
        
        addSubview(couponLabel)
        couponLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(termsLabel.snp.bottom).offset(16)
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
    
    // MARK: Actions
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

// MARK: Public Methods
extension SubscriptionOverlayView {
    
    public func resetProduct() {
        presentedProductViewArray.removeAll()
        productStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    public func setCouponButton(isHidden: Bool){
        couponLabel.isHidden = isHidden
    }
    
    public func createProduct(item: PresentableProduct){
        let productItemView = ProductItemView()
        presentedProductViewArray.append(productItemView)
        productItemView.set(id: item.sku, title: item.title, description: item.description + " - " + item.price)
        productItemView.delegate = self
        productItemView.set(isSelected: item.isSelected)
        productItemView.set(isBest: item.isBest)
        productItemView.set(isDiscounted: item.isDiscounted)
        productStackView.addArrangedSubview(productItemView)
        
        productItemView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    public func setSelectedItem(sku: String) {
        presentedProductViewArray.forEach { item in
            if let viewProductId = item.productID {
                item.set(isSelected: sku == viewProductId)
            }
        }
    }
    
}

// MARK: ProductItemViewDelegate
extension SubscriptionOverlayView: ProductItemViewDelegate {
    func productSelected(id: String?) {
        delegate?.productSelected(id: id)
    }
    
}
