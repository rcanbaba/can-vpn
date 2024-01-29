//
//  ProductBadgeView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 29.01.2024.
//

import UIKit

class ProductBadgeView: UIView {

    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        baseView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    public func set(isDiscounted: Int) {
        // TODO: key
        titleLabel.text = "%" + "\(isDiscounted)" + " " + "Discounted"
        baseView.backgroundColor = UIColor.Subscription.discountedBadgeBack
    }
    
    public func set(isBest: Bool) {
        // TODO: key
        titleLabel.text = "Best Value"
        baseView.backgroundColor = UIColor.Subscription.bestBadgeBack
    }
    
}
