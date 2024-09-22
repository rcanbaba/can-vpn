//
//  PaywallViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.09.2024.
//

import UIKit

class PaywallViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    
    private lazy var getButton: NewOfferButton = {
        let view = NewOfferButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "Start Subscription".localize()
        view.setGreeneUI()
        return view
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Use"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy Policy"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var lineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vertical-line")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let paywallData: [PaywallPageItemModel] = [
        PaywallPageItemModel(image: UIImage(named: "paywall-fast-1-img"), title: "Blazing Fast Speeds", description: "Enjoy uninterrupted browsing and streaming with our high-speed servers."),
        PaywallPageItemModel(image: UIImage(named: "paywall-secure-2-img"), title: "Top-Notch Security", description: "Protect your data with industry-leading encryption and advanced security protocols."),
        PaywallPageItemModel(image: UIImage(named: "paywall-anon-3-img"), title: "Complete Anonymity", description: "Surf the web with complete privacy, hiding your identity from prying eyes."),
        PaywallPageItemModel(image: UIImage(named: "paywall-loc-4-img"), title: "10+ Worldwide Locations", description: "Access servers in over 10 countries for a truly global online experience.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupCollectionView()
        setupPageControl()
        
        view.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.equalToSuperview().inset(65)
            make.height.equalTo(60)
        }
        
        let stackView = UIStackView(arrangedSubviews: [termsLabel, privacyLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(getButton.snp.bottom).offset(20)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(2)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.3)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaywallCell.self, forCellWithReuseIdentifier: "PaywallCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white

        let screenHeight = UIScreen.main.bounds.height
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.35)
        }

    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = paywallData.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pageControl.currentPageIndicatorTintColor = UIColor.NewSubs.selectedPage
        pageControl.pageIndicatorTintColor = UIColor.NewSubs.unselectedPage
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        // TODO: can
        //   self.subscribeOffer()
    }
}

extension PaywallViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paywallData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaywallCell", for: indexPath) as! PaywallCell
        let model = paywallData[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

