//
//  LanguageListTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 31.10.2023.
//

import UIKit

class LanguageListTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = UIColor.Custom.green
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        let selectedBackgroundView1 = UIView()
        selectedBackgroundView1.layer.cornerRadius = 16.0
        selectedBackgroundView1.backgroundColor = UIColor.Custom.goPreGrayText.withAlphaComponent(0.5)
        self.selectedBackgroundView = selectedBackgroundView1
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
}
