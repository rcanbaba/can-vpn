//
//  ReviewItemView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 27.01.2024.
//
import UIKit

class ReviewItemView: UIView {

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoStackView, reviewTextLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6.0
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, cityLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var pointLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "5".localize()
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "review-item-star")
        return imageView
    }()
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointLabel, starImageView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Mahmoot Jon"
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Ankara, Turkey"
        return label
    }()
    
    private lazy var reviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "I am very happy to use this vpn thank you it turned out than"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func configureUI() {
        self.backgroundColor = .cyan
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(9.6)
        }
        
        addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
        }
    }
    
}
