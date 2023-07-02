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
        return view
    }()
    
    private lazy var periodLabel: UILabel = {
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
    
    private lazy var perIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        
        mainView.layer.applySketchShadow(color: UIColor.Custom.actionButtonShadow, alpha: 0.2, x: 0, y: 0, blur: 8, spread: 0)
        
        mainView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        mainView.addSubview(perIntervalLabel)
        perIntervalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        mainView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(perIntervalLabel.snp.leading).offset(-5)
        }

    }
    
    private func configureAsSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.layer.borderColor = UIColor.Custom.offerButtonBorderOrange.cgColor
        }
        periodLabel.textColor = UIColor.Custom.offerButtonTextOrange
        perIntervalLabel.textColor = UIColor.Custom.offerButtonTextOrange
        priceLabel.textColor = UIColor.Custom.offerButtonTextOrange
    }
    
    private func configureAsNotSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.layer.borderColor = UIColor.Custom.offerButtonBorderGray.cgColor
        }
        periodLabel.textColor = UIColor.Custom.offerButtonTextGray
        perIntervalLabel.textColor = UIColor.Custom.offerButtonTextGray
        priceLabel.textColor = UIColor.Custom.offerButtonTextGray
    }
    
}

extension OfferTableViewCell {
    public func setName(text: String) {
        periodLabel.text = text
    }
}
