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
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .trailing
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var discountTagBGImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discount-tag-bg-img")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private lazy var discountTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var bestTagBGImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "best-tag-bg-img")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private lazy var flameIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flame-icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var bestTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .natural
        label.text = "best_tag".localize()
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
        configureUI()
        configureTagUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func configureUI() {
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(3)
        }
        
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
        
        mainView.layer.applySketchShadow()
    }
    
    private func configureTagUI() {
        contentView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView.snp.bottom)
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(24)
        }
        
        bestTagBGImageView.snp.makeConstraints { (make) in
            make.height.equalTo(26)
        }
        
        discountTagBGImageView.snp.makeConstraints { (make) in
            make.height.equalTo(26)
        }
        
        bestTagBGImageView.addSubview(flameIconImageView)
        flameIconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(12.5)
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview().offset(-4)
        }
        bestTagBGImageView.addSubview(bestTagLabel)
        bestTagLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(flameIconImageView.snp.trailing).offset(3)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview().offset(-4)
        }
        
        discountTagBGImageView.addSubview(discountTagLabel)
        discountTagLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview().offset(-4)
        }
        
    }
    
    private func configureAsSelected() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.layer.borderColor = UIColor.Custom.offerButtonBorderOrange.cgColor
        }
        planLabel.textColor = UIColor.Custom.offerButtonTextOrange
        descriptionLabel.textColor = UIColor.Custom.offerButtonTextOrange
        priceLabel.textColor = UIColor.Custom.offerButtonTextOrange
        shakeAnimation(for: bestTagBGImageView, delay: 0.0)
        shakeAnimation(for: discountTagBGImageView, delay: 0.0)
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
    public func showDiscountTag(percentage: Int) {
        discountTagLabel.text = "\(percentage)% " + "discount_tag".localize()
        tagStackView.addArrangedSubview(discountTagBGImageView)
        tagStackView.layoutIfNeeded()
        tagStackView.setNeedsLayout()
    }
    public func showBestTag(){
        tagStackView.addArrangedSubview(bestTagBGImageView)
        tagStackView.layoutIfNeeded()
        tagStackView.setNeedsLayout()
    }
}

func shakeAnimation(for imageView: UIImageView, delay: Double) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shake.values = [4, -4, 2, -2, 0]
        shake.duration = 0.5
        shake.repeatCount = 1
        imageView.layer.add(shake, forKey: "shake")
    }
}
