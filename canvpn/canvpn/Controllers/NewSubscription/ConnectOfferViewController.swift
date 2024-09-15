//
//  ConnectOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.09.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class ConnectOfferViewController: UIViewController {
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "back-offer-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NewSubs.green
        return view
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "connect-offer-top-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "Boost Your Speed1".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "You're on a slower connection right now. Upgrade to Premium for lightning-fast browsing.2".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var getButton: LandingButton = {
        let view = LandingButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "Boost Now".localize()
        return view
    }()
    
    private let testimonials: [(name: String, message: String)] = [
        ("Emily R.", "Incredibly fast! I noticed the difference as soon as I upgraded to premium."),
        ("Alex M.", "I can connect to any server instantly and with great speed. Awesome!"),
        ("John P.", "Amazing performance, especially for the price. So glad I upgraded!")
    ]
    
    private var circularTestimonials: [(name: String, message: String)] {
        return testimonials + testimonials + testimonials
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 164, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TestimonialCell.self, forCellWithReuseIdentifier: TestimonialCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        Analytics.logEvent("ConnectOfferPresented", parameters: [:])
        super.viewDidLoad()
        configureUI()
        setupCollectionViewScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("053ConnectOfferPresented", parameters: ["type" : "willAppear"])
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func setupCollectionViewScroll() {
        let middleIndexPath = IndexPath(item: circularTestimonials.count / 3, section: 0)
        collectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    private func configureUI() {
        view.addSubview(topBackView)
        view.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        topBackView.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.bottom.equalTo(topImageView.snp.bottom).inset(5)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(topImageView.snp.bottom).inset(10)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(35)
            make.top.equalTo(topImageView.snp.bottom).offset(34)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(24)
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
        }
        
        view.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(65)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
        
    }
    
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        // TODO: can
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        // TODO: can
    }
    
}

extension ConnectOfferViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return circularTestimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestimonialCell.reuseIdentifier, for: indexPath) as! TestimonialCell
        let testimonial = circularTestimonials[indexPath.item]
        cell.configure(with: testimonial.name, message: testimonial.message)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let midpoint = circularTestimonials.count / 2
        let indexPaths = collectionView.indexPathsForVisibleItems.sorted()
        
        guard let firstIndexPath = indexPaths.first else { return }
        guard let lastIndexPath = indexPaths.last else { return }

        if lastIndexPath.item < testimonials.count {
            let newIndexPath = IndexPath(item: lastIndexPath.item + testimonials.count, section: 0)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        } else if firstIndexPath.item >= 2 * testimonials.count {
            let newIndexPath = IndexPath(item: firstIndexPath.item - testimonials.count, section: 0)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
}
