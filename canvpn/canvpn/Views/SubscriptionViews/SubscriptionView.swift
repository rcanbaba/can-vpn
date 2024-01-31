//
//  SubscriptionView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class SubscriptionView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "subs_page_title".localize()
        return label
    }()
    
    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "premium-crown-top")
        return imageView
    }()
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.locations = [0.0, 1.0]
        gradientView.gradientLayer.colors = [
            UIColor.Landing.backGradientStart.cgColor,
            UIColor.Landing.backGradientEnd.cgColor
        ]
        return gradientView
    }()
    
    public lazy var featuresTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeaturesTableViewCell.self, forCellReuseIdentifier: "FeaturesTableViewCell")
        tableView.rowHeight = 38
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = true
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        tableView.layer.cornerRadius = 12
        return tableView
    }()
    
    private lazy var branchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [preBranch1ImageView, preBranch2ImageView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var preBranch1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pre-branch-img1")
        return imageView
    }()
    
    private lazy var preBranch2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pre-branch-img2")
        return imageView
    }()
    
    private lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6.0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func configureUI() {
        backgroundColor = .clear
        
        let edgeSize = UIScreen.main.bounds.width / 2.5
        
        addSubview(crownImageView)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
        
        crownImageView.snp.makeConstraints { make in
            make.size.equalTo(edgeSize)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel).offset(12)
        }
        
        addSubview(featuresTableView)
        featuresTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(200)
        }
        
        featuresTableView.layer.applySubscriptionShadow()
        featuresTableView.clipsToBounds = false
        
        addSubview(branchStackView)
        branchStackView.snp.makeConstraints { make in
            make.top.equalTo(featuresTableView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        addSubview(reviewStackView)
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(branchStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
    }
}

// MARK: Public methods
extension SubscriptionView {
    public func createReviews(dataArray: [ReviewItem]) {
        for reviewData in dataArray {
            let reviewItem = ReviewItemView()
            reviewItem.set(point: reviewData.point, name: reviewData.name, city: reviewData.city, text: reviewData.text)
            reviewStackView.addArrangedSubview(reviewItem)
            
            reviewItem.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
        }
    }
}
