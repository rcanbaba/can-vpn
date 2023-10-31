//
//  PremiumFeatureView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.03.2023.
//

import UIKit

class PremiumFeatureView: UIView {
    
    private lazy var premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.goProFeatureTextGray
        label.textAlignment = .natural
        label.numberOfLines = 0
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
        addSubview(premiumImageView)
        premiumImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.size.equalTo(30)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(premiumImageView.snp.trailing).offset(10)
            make.centerY.equalTo(premiumImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(4)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumImageView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
}

extension PremiumFeatureView {    
    public func set(type: PremiumFeatureType) {
        titleLabel.text = type.getTitle()
        descriptionLabel.text = type.getDescription()
        premiumImageView.image = type.getImage()
        
        if type == .noAds {
            premiumImageView.contentMode = .scaleAspectFit
        } else {
            premiumImageView.contentMode = .scaleToFill
        }
    }
}
