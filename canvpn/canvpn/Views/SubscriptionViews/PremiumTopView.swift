//
//  PremiumTopView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 21.06.2023.
//

import UIKit

class PremiumTopView: UIView {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [premiumImageView, titleLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        return stackView
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
        label.text = "premium_feature_title".localize()
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
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        premiumImageView.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(74)
        }
        
    }
    
}
