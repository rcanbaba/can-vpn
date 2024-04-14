//
//  LocationButtonView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.03.2023.
//

import UIKit

class LocationButton: UIView {
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 2.0
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.Custom.gray.cgColor
        return imageView
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var ipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var signalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "signal-4-green-icon")
        return imageView
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "right-arrow-icon")
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var signalTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .natural
        return label
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
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 12
        layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        addSubview(flagImageView)
        flagImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(35)
        }
        
        addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        addSubview(signalImageView)
        signalImageView.snp.makeConstraints { make in
            make.trailing.equalTo(rightArrowImageView.snp.leading).inset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(22)
        }
        
        addSubview(signalTextLabel)
        signalTextLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(signalImageView.snp.leading).offset(-12)
            make.centerY.equalToSuperview().offset(2)
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(flagImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview().inset(9)
            make.trailing.equalTo(signalImageView.snp.leading).inset(-12)
        }
    }
}

extension LocationButton {
    
    public func set(country: String?) {
        countryLabel.text = country
    }
    
    public func set(ip: String?) {
        if ip == nil {
            ipLabel.removeFromSuperview()
        } else {
            mainStackView.addArrangedSubview(ipLabel)
            ipLabel.text = ip
        }
    }
    
    public func set(flagImageCountryCode: String?) {
        flagImageView.image = UIImage(named: flagImageCountryCode ?? "tr")
    }
    
    public func set(signalImage: UIImage?) {
        signalImageView.image = signalImage
    }
    
    public func set(signalText: String) {
        signalTextLabel.text = signalText
    }
    
    public func set(signalTextColor: UIColor) {
        signalTextLabel.textColor = signalTextColor
    }
    
}
