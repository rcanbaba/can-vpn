//
//  FeaturesTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.01.2024.
//

import UIKit

class FeaturesTableViewCell: UITableViewCell {
    
    private lazy var firstCheckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "features-untick-icon")
        return imageView
    }()
    
    private lazy var secondCheckImageView: UIImageView = {
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
    
    private lazy var checkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstCheckImageView, secondCheckImageView])
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 12
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
        contentView.addSubview(checkStackView)
        checkStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkStackView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        firstCheckImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        secondCheckImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}

extension FeaturesTableViewCell {
    public func set(type: PremiumFeatureType) {
        titleLabel.text = type.getTitle()
        descriptionLabel.text = type.getDescription()
        firstCheckImageView.image = type.getFreeCheck() ? UIImage(named: "features-tick-icon") : UIImage(named: "features-untick-icon")
        addShineEffect(to: secondCheckImageView)
    }
}
