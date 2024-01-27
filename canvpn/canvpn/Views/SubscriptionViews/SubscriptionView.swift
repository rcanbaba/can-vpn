//
//  SubscriptionView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit

class SubscriptionView: UIView {
    
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
    
    public lazy var offerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: "OfferTableViewCell")
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        return tableView
    }()
    
    public lazy var featuresTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeaturesTableViewCell.self, forCellReuseIdentifier: "FeaturesTableViewCell")
        tableView.rowHeight = 38
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = true
        tableView.indicatorStyle = .black
        tableView.backgroundColor = UIColor.white
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Get Premium1".localize()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createReviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Setup UI
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(4)
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
        
//        addSubview(subscribeButton)
//        subscribeButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(36)
//            make.height.equalTo(48)
//            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
//        }
//        
//        addSubview(termsLabel)
//        termsLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(24)
//            make.top.equalTo(subscribeButton.snp.bottom).offset(13)
//        }
//        
//        addSubview(restoreLabel)
//        restoreLabel.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(24)
//            make.top.equalTo(subscribeButton.snp.bottom).offset(13)
//        }
//        
//        addSubview(couponLabel)
//        couponLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(subscribeButton.snp.top).offset(-13)
//        }
//        
//        addSubview(offerTableView)
//        offerTableView.snp.makeConstraints { make in
//            make.top.equalTo(reviewStackView.snp.bottom).offset(30)
//            make.leading.trailing.equalToSuperview().inset(24)
//            make.bottom.equalTo(subscribeButton.snp.top).offset(-32)
//        }
//        
//        addSubview(activityIndicator)
//        activityIndicator.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }

    }
    
    private func createReviews() {
        let reviewItem1 = ReviewItemView()
        reviewItem1.set(point: "5", name: "Can Babaoglu", city: "Turkey", 
                        text: "Çok güzel uygulama harika ben çok sevdim")
        let reviewItem2 = ReviewItemView()
        reviewItem2.set(point: "5", name: "Can Babaoglu", city: "Turkey", 
                        text: "Çok güzel uygulama harika ben çok sevdim, daha fazla sunucu eklerseniz harika olur.")
        let reviewItem3 = ReviewItemView()
        reviewItem3.set(point: "4", name: "Can Babaoglu", city: "Turkey", 
                        text: "Bağlanırken 1 defa sıkıntı yaşadım sonrasında uygulamayı kapatıp açılınca düzeldi, bu sorunla ilgilenir misiniz?")
        let reviewItem4 = ReviewItemView()
        reviewItem4.set(point: "5", name: "Can Babaoglu", city: "Turkey", 
                        text: "Çok Hızlı")
        let reviewItem5 = ReviewItemView()
        reviewItem5.set(point: "4", name: "Can Babaoglu", city: "Turkey", 
                        text: "Free olması harika")
        let reviewItem6 = ReviewItemView()
        reviewItem6.set(point: "5", name: "Can Babaoglu", city: "Turkey", 
                        text: "Premium sunucular çok hızlı")
        let reviewItem7 = ReviewItemView()
        reviewItem7.set(point: "5", name: "Can Babaoglu", city: "Turkey",
                        text: "Premium sunucular çok hızlı")
        let reviewItem8 = ReviewItemView()
        reviewItem8.set(point: "5", name: "Can Babaoglu", city: "Turkey",
                        text: "Premium sunucular çok hızlı")
        let reviewItem9 = ReviewItemView()
        reviewItem9.set(point: "5", name: "Can Babaoglu", city: "Turkey",
                        text: "Premium sunucular çok hızlı")
        
        reviewStackView.addArrangedSubview(reviewItem1)
        reviewStackView.addArrangedSubview(reviewItem2)
        reviewStackView.addArrangedSubview(reviewItem3)
        reviewStackView.addArrangedSubview(reviewItem4)
        reviewStackView.addArrangedSubview(reviewItem5)
        reviewStackView.addArrangedSubview(reviewItem6)
        reviewStackView.addArrangedSubview(reviewItem7)
        reviewStackView.addArrangedSubview(reviewItem8)
        reviewStackView.addArrangedSubview(reviewItem9)
        
        reviewItem1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem4.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem5.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem6.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem7.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem8.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        reviewItem9.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
    }
}

// MARK: - PUBLIC METHODS
extension SubscriptionView {
    public func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    public func setCouponLabel(isHidden: Bool) {
        couponLabel.isHidden = isHidden
    }
}
