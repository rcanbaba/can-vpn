//
//  GoProButton.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.03.2023.
//

import UIKit

class GoProButton: UIView {
    
    private lazy var premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "go-pro-image")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .natural
        label.text = "upgrade_pro".localize()
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.Custom.goPreGrayText
        label.textAlignment = .natural
        label.text = "upgrade_pro_detail".localize()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "go-pro-right-arrow")
        return imageView
    }()
    
    private lazy var rightArrowBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.goPreButtonGold
        view.layer.cornerRadius = 9.0
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = -10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
        layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        addSubview(premiumImageView)
        premiumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(74)
            make.width.equalTo(72)
        }
        
        addSubview(rightArrowBackView)
        rightArrowBackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(74)
        }
        
        rightArrowBackView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.center.equalToSuperview()
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(premiumImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview().inset(9)
            make.trailing.equalTo(rightArrowBackView.snp.leading).inset(-10)
        }
    }
    
    private func setAsPremium() {
        rightArrowBackView.isHidden = true
        titleLabel.text = "upgraded_to_pro".localize()
        detailLabel.text = "upgraded_to_pro_detail".localize()
        isUserInteractionEnabled = false
        
        mainStackView.snp.remakeConstraints { make in
            make.leading.equalTo(premiumImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview().inset(9)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func setAsStandard() {
        rightArrowBackView.isHidden = false
        titleLabel.text = "upgrade_pro".localize()
        detailLabel.text = "upgrade_pro_detail".localize()
        isUserInteractionEnabled = true
        
        mainStackView.snp.remakeConstraints { make in
            make.leading.equalTo(premiumImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview().inset(9)
            make.trailing.equalTo(rightArrowBackView.snp.leading).inset(-10)
        }
    }
    
}

// MARK: - public methods
extension GoProButton {
    public func setState(isPremium: Bool) {
        isPremium ? setAsPremium() : setAsStandard()
    }
}
