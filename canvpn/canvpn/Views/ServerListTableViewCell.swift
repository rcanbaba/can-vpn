//
//  ServerListTableViewCell.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {
    
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
        contentView.layer.backgroundColor = UIColor(red: 0, green: 17/255, blue: 30/255, alpha: 0.5).cgColor

        self.contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(17)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        self.contentView.addSubview(countryNameLabel)
        countryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(17)
            make.top.bottom.equalToSuperview()
        }
    }
}
