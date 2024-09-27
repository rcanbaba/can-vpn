//
//  PaywallProductView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 26.09.2024.
//

import UIKit

protocol PaywallProductViewDelegate: AnyObject {
    func productSelected(id: String?)
}

class PaywallProductView: UIView {
    
    weak var delegate: PaywallProductViewDelegate?
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .left
        label.text = "Weekly".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .right
        label.text = "$0.99".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var oldPriceLabel: StrikethroughLabel = {
        let label = StrikethroughLabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.NewSubs.oldGray
        label.textAlignment = .right
        label.text = "$1.99".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var discountView: ConnectDiscountView = {
        let view = ConnectDiscountView()
        view.isHidden = true
        return view
    }()
    
    public var productID: String? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setAsDeselected()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureUI() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(13)
        }
        
        addSubview(newPriceLabel)
        newPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(productNameLabel.snp.centerY)
        }
        
        addSubview(oldPriceLabel)
        oldPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(newPriceLabel.snp.top).inset(-7)
        }
        
        addSubview(discountView)
        discountView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(28.5)
        }
        
    }
    
    private func setAsDeselected() {
        layer.borderColor = UIColor.NewSubs.gray.cgColor
        backgroundColor = UIColor.clear
    }
    
    private func setAsSelected() {
        backgroundColor = UIColor.NewSubs.green.withAlphaComponent(0.15)
        layer.borderColor = UIColor.NewSubs.green.cgColor
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.productSelected(id: productID)
    }
    
}

// MARK: - Public methods
extension PaywallProductView {
    public func set(productNameText: String) {
        productNameLabel.text = productNameText
    }
    
    public func set(newPriceText: String) {
        newPriceLabel.text = newPriceText
    }
    
    public func set(oldPriceText: String) {
        oldPriceLabel.text = oldPriceText
    }
    
    public func set(id: String){
        productID = id
    }
    
    public func set(isDiscounted: Int) {
        if isDiscounted > 0 {
            discountView.isHidden = false
            discountView.discountLabel.text = "% \(isDiscounted)"
        }
    }
    
    public func set(isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.setAsSelected()
            }
        } else {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.setAsDeselected()
            }
        }
    }
    
}
