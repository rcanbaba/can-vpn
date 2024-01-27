//
//  ReviewItemView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 27.01.2024.
//
import UIKit

class ReviewItemView: UIView {
    
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8.0
        view.layer.applySubscriptionShadow()
        return view
    }()

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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
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
        return stackView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var reviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor.Subscription.reviewText
        label.textAlignment = .natural
        label.numberOfLines = 3
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
        backgroundColor = .clear
        
        addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        baseView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        
        baseView.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    public func set(point: String, name: String, city: String, text: String){
        pointLabel.text = point
        userNameLabel.text = name
        cityLabel.text = city
        reviewTextLabel.text = text
    }
    
}
