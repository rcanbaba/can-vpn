//
//  PaywallCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.09.2024.
//

import UIKit

class PaywallCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.NewSubs.dark
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.NewSubs.dark
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 14
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }

    }
    
    func configure(with model: PaywallPageItemModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

