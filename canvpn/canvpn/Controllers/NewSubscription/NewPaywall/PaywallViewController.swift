//
//  PaywallViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.09.2024.
//

import UIKit
import StoreKit

class PaywallViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
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
    
    private let promoLabel: UILabel = {
        let label = UILabel()
        label.text = "I have a promo code"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    // TODO: localize
    let paywallData: [PaywallPageItemModel] = [
        PaywallPageItemModel(image: UIImage(named: "paywall-fast-1-img"), title: "Blazing Fast Speeds", description: "Enjoy uninterrupted browsing and streaming with our high-speed servers."),
        PaywallPageItemModel(image: UIImage(named: "paywall-secure-2-img"), title: "Top-Notch Security", description: "Protect your data with industry-leading encryption and advanced security protocols."),
        PaywallPageItemModel(image: UIImage(named: "paywall-anon-3-img"), title: "Complete Anonymity", description: "Surf the web with complete privacy, hiding your identity from prying eyes."),
        PaywallPageItemModel(image: UIImage(named: "paywall-loc-4-img"), title: "10+ Worldwide Locations", description: "Access servers in over 10 countries for a truly global online experience.")
    ]
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    private lazy var presentedProductViewArray: [NewProductView] = []
    
    private var selectedOfferSKU: String?
    private var appliedCouponCode: String?
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService = DefaultNetworkService()
        checkAndSetProducts()
        checkThenSetCouponLabel()
        configureUI()
    }
    
    // MARK: - Configure UI -
    private func configureUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupBottomUI()
        setupScrollView()
        setupCollectionView()
        setupPageControl()
        setGestureRecognizer()
        setupProductStackView()
        configureActivityIndicatorUI()
    }
    
    private func setupBottomUI() {
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
        
        view.addSubview(promoLabel)
        promoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(getButton.snp.top).inset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - navigation bar
    private func setupNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "black-back-icon"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        // Custom restore button
        let restoreButton = UIButton(type: .custom)
        restoreButton.setTitle("Restore", for: .normal)
        restoreButton.setTitleColor(UIColor.NewSubs.gray, for: .normal)
        restoreButton.frame = CGRect(x: 0, y: 0, width: 120, height: 24)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        let restoreBarButtonItem = UIBarButtonItem(customView: restoreButton)
        navigationItem.rightBarButtonItem = restoreBarButtonItem
        
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(getButton.snp.top).offset(-20)
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
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
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.35)
        }
    }
    
    private func setupProductStackView() {
        productStackView.axis = .vertical
        productStackView.spacing = 15
        productStackView.alignment = .fill
        productStackView.distribution = .fillEqually
        
        contentView.addSubview(productStackView)
        productStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = paywallData.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.currentPageIndicatorTintColor = UIColor.NewSubs.selectedPage
        pageControl.pageIndicatorTintColor = UIColor.NewSubs.unselectedPage
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureActivityIndicatorUI() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - SET DATA
extension PaywallViewController {
    
    private func checkThenSetCouponLabel() {
        let showCoupon = SettingsManager.shared.settings?.interface.showCoupon ?? false
        promoLabel.isHidden = !showCoupon
    }
    
    private func checkAndSetProducts() {
        products = PurchaseManager.shared.products
        presentableProducts = SettingsManager.shared.settings?.products ?? []
        setProducts()
    }
    
    private func setProducts() {
        resetProduct()
        presentableProducts.forEach { product in
            if let storeProduct = getSKProduct(skuID: product.sku), let storePrice = PurchaseManager.shared.getPriceFormatted(for: storeProduct) {
                
                let presentableProduct = PresentableProduct(sku: product.sku,
                                                            title: getProductName(key: storeProduct.localizedTitle),
                                                            description: getProductDescription(key: storeProduct.localizedDescription),
                                                            price: storePrice,
                                                            isSelected: product.isPromoted,
                                                            isBest: product.isBestOffer,
                                                            isDiscounted: product.discount)
                
                selectedOfferSKU = product.isPromoted ? product.sku : selectedOfferSKU
                createProduct(item: presentableProduct)
            }
            
        }
    }
    
    private func createProduct(item: PresentableProduct) {
        let productItemView = NewProductView()
        presentedProductViewArray.append(productItemView)
        
        productItemView.setGreenUI() // Set the UI style
        productItemView.set(discountText: "\(item.isDiscounted)")
        productItemView.set(newPriceText: item.price)
        productItemView.set(oldPriceText: item.price + "oldi")
        productItemView.set(productNameText: item.title)
        
//        productItemView.set(id: item.sku, title: item.title, description: item.description + " - " + item.price)
//        productItemView.delegate = self
//        productItemView.set(isSelected: item.isSelected)
//        productItemView.set(isBest: item.isBest)
//        productItemView.set(isDiscounted: item.isDiscounted)
        
        productStackView.addArrangedSubview(productItemView)
        
        productItemView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func configureProducts(products: [PresentableProduct]) {
        let productData: [(discountText: String, newPriceText: String, oldPriceText: String, productNameText: String)] = [
            ("%30", "$4.99", "$8.99", "Monthly"),
            ("%10", "$1.99", "$2.99", "Weekly"),
            ("%1023", "$1.9239", "$2.9339", "Week23ly"),
            ("%1044", "$1.9449", "$2.949", "Week444ly")
        ]
        
        // Loop through the data and generate product views
        for product in productData {
            let productView = NewProductView()
            productView.setGreenUI() // Set the UI style
            productView.set(discountText: product.discountText)
            productView.set(newPriceText: product.newPriceText)
            productView.set(oldPriceText: product.oldPriceText)
            productView.set(productNameText: product.productNameText)
            
            productStackView.addArrangedSubview(productView)
            productView.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }
    
    
    
    private func resetProduct() {
        presentedProductViewArray.removeAll()
        productStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func getSKProduct(skuID: String) -> SKProduct? {
        return products?.first(where: { $0.productIdentifier == skuID})
    }
    
    // TODO: for set different names
    private func getProductName(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
    
    private func getProductDescription(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
}

// MARK: - gesture recognizers - flows
extension PaywallViewController {
    private func showSubscriptionTerms() {
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showPrivacyPage() {
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        guard let url = URL(string: ppDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
        
        let promoTapGesture = UITapGestureRecognizer(target: self, action: #selector(promoLabelTapped(_:)))
        promoLabel.addGestureRecognizer(promoTapGesture)
        promoLabel.isUserInteractionEnabled = true
    }

}


// MARK: - Actions -
extension PaywallViewController {
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        showSubscriptionTerms()
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        showPrivacyPage()
    }
    
    @objc func promoLabelTapped(_ gesture: UITapGestureRecognizer) {
        // TODO: implement coupon
        print("Coupon button tapped")
    }

    @objc private func restoreButtonTapped() {
        // TODO: implement restore
        print("Restore button tapped")
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        // TODO: can
        //   self.subscribeOffer()
    }
    
    
}

// MARK: - CollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout -
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

