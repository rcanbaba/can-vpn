//
//  OfferTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.07.2023.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 2.5
        view.layer.borderColor = UIColor.Custom.offerButtonBorderGray.cgColor
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.Custom.offerButtonTextGray
        label.textAlignment = .left
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            configureAsSelected()
        } else {
            configureAsNotSelected()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(3)
        }
        
     //   mainView.layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        mainView.addSubview(planLabel)
        planLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().inset(24)
        }
        
        mainView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        mainView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(planLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(priceLabel.snp.leading).inset(12)
        }
    }
    
    private func configureAsSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.layer.borderColor = UIColor.Custom.offerButtonBorderOrange.cgColor
        }
        planLabel.textColor = UIColor.Custom.offerButtonTextOrange
        descriptionLabel.textColor = UIColor.Custom.offerButtonTextOrange
        priceLabel.textColor = UIColor.Custom.offerButtonTextOrange
    }
    
    private func configureAsNotSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.layer.borderColor = UIColor.Custom.offerButtonBorderGray.cgColor
        }
        planLabel.textColor = UIColor.Custom.offerButtonTextGray
        descriptionLabel.textColor = UIColor.Custom.offerButtonTextGray
        priceLabel.textColor = UIColor.Custom.offerButtonTextGray
    }
    
}

extension OfferTableViewCell {
    public func setName(text: String) {
        planLabel.text = text
    }
    
    public func setPrice(text: String) {
        priceLabel.text = text
    }
    
    public func setDescription(text: String) {
        descriptionLabel.text = text
    }
    
}
