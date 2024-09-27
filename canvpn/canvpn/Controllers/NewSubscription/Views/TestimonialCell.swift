//
//  TestimonialCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit
import SnapKit

class TestimonialCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TestimonialCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor.NewSubs.dark
        label.numberOfLines = 0
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.NewSubs.gold
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var commaView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comma-icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(messageLabel)
        backView.addSubview(starsLabel)
        
        contentView.addSubview(commaView)
        
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.NewSubs.gray.cgColor
        backView.layer.cornerRadius = 10
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10).priority(.high)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(25).priority(.low)
        }
        
        starsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(15)
        }
        
        commaView.snp.makeConstraints { make in
            make.width.equalTo(19)
            make.height.equalTo(38)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(-9)
        }
        
    }
    
    func configure(with name: String, message: String) {
        nameLabel.text = name
        messageLabel.text = message
        let randomNumber = Int.random(in: 1...5)
        let reviewString = randomNumber == 1 ? "4 ★★★★" : "5 ★★★★★"
        
        starsLabel.text = reviewString
    }
}
