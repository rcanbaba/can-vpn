//
//  ServerListTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {
    
    // TODO: add fade-in out animation
    public var isChecked = false {
        didSet {
            if isChecked {
                checkImageView.image = UIImage(named: "checked-icon")
            } else {
                checkImageView.image = UIImage(named: "unchecked-icon")
            }
            self.layoutIfNeeded()
        }
    }
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var countryNameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    public lazy var flagImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(17)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        self.contentView.addSubview(countryNameLabel)
        countryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(flagImageView.snp.trailing).offset(17)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(17)
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
    }
}
