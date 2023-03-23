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
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16.0
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        mainView.layer.applySketchShadow()
        
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
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(60)
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
}
