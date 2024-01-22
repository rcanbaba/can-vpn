//
//  FeaturesTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.01.2024.
//

import UIKit

class FeaturesTableViewCell: UITableViewCell {
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "features-tick-icon")
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.Subscription.featureTitleText
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.Subscription.featureDescriptionText
        label.textAlignment = .natural
        label.numberOfLines = 1
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
}

extension FeaturesTableViewCell {
    public func set(type: PremiumFeatureType) {
        titleLabel.text = type.getTitle()
        descriptionLabel.text = type.getDescription()
    }
}
