//
//  ServerListTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import UIKit

class LocationListTableViewCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.Custom.gray.cgColor
        return view
    }()
    
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
    
    private lazy var signalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "signal-4-green-icon")
        return imageView
    }()
    
    private lazy var proImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pro-crown-icon")
        return imageView
    }()
    
    private lazy var signalTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .natural
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        // mainView.layer.applySketchShadow()
        
        mainView.layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(6)
        }

        mainView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(35)
        }
        
        mainView.addSubview(signalImageView)
        signalImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(22)
        }
        
        mainView.addSubview(proImageView)
        proImageView.snp.makeConstraints { make in
            make.trailing.equalTo(signalImageView.snp.leading).inset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        mainView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(flagImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().inset(60)
        }
        
        mainView.addSubview(signalTextLabel)
        signalTextLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(proImageView.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}

extension LocationListTableViewCell {
    
    public func set(isPremium: Bool) {
        proImageView.isHidden = !isPremium
    }
    
    public func set(country: String?) {
        countryLabel.text = country
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
