//
//  ProductItemView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.01.2024.
//

import UIKit

protocol ProductItemViewDelegate: AnyObject {
    func productSelected(id: String?)
}

class ProductItemView: UIView {
    
    weak var delegate: ProductItemViewDelegate?
    
    public var productID: String? = nil
    
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12.0
        view.layer.applySubscriptionShadow()
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6.0
        stackView.backgroundColor = UIColor.white
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var badgeView = ProductBadgeView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
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
            make.top.bottom.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        badgeView.isHidden = true
        baseView.addSubview(badgeView)
        badgeView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.productSelected(id: productID)
    }
    
    public func set(id: String, title: String, description: String){
        productID = id
        badgeView.isHidden = true
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    public func set(isBest: Bool) {
        if isBest {
            badgeView.isHidden = false
            badgeView.set(isBest: true)
        }
    }
    
    public func set(isDiscounted: Int) {
        if isDiscounted > 0 {
            badgeView.isHidden = false
            badgeView.set(isDiscounted: isDiscounted)
        }
    }
    
    public func set(isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.baseView.layer.borderColor = UIColor.Subscription.productSelectedBorder.cgColor
                self?.baseView.layer.borderWidth = 2.0
            }
        } else {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.baseView.layer.borderColor = UIColor.clear.cgColor
                self?.baseView.layer.borderWidth = 0.0
            }
        }
    }
    
}
