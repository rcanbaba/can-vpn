//
//  PaywallViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.09.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

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
        view.textLabel.text = "paywall_button".localize()
        view.setGreeneUI()
        return view
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "terms_of_service_key".localize()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "privacy_policy_key".localize()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let promoLabel: UILabel = {
        let label = UILabel()
        label.text = "paywall_promo_text".localize()
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
    
    private lazy var backNavigationButton = UIButton(type: .custom)
    private lazy var restoreNavigationButton = UIButton(type: .custom)
    
    let paywallData: [PaywallPageItemModel] = [
        PaywallPageItemModel(
            image: UIImage(named: "paywall-fast-1-img"),
            title: "paywall_item_1_title".localize(),
            description: "paywall_item_1_description".localize()
        ),
        PaywallPageItemModel(
            image: UIImage(named: "paywall-secure-2-img"),
            title: "paywall_item_2_title".localize(),
            description: "paywall_item_2_description".localize()
        ),
        PaywallPageItemModel(
            image: UIImage(named: "paywall-anon-3-img"),
            title: "paywall_item_3_title".localize(),
            description: "paywall_item_3_description".localize()
        ),
        PaywallPageItemModel(
            image: UIImage(named: "paywall-loc-4-img"),
            title: "paywall_item_4_title".localize(),
            description: "paywall_item_4_description".localize()
        )
    ]
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    private lazy var presentedProductViewArray: [PaywallProductView] = []
    
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.leading.trailing.equalToSuperview().inset(65)
            make.height.equalTo(60)
        }
        
        let stackView = UIStackView(arrangedSubviews: [termsLabel, privacyLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(16)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(2)
        }
        
        view.addSubview(promoLabel)
        promoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(getButton.snp.top).inset(-2)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - navigation bar
    private func setupNavigationBar() {
        backNavigationButton.setImage(UIImage(named: "black-back-icon"), for: .normal)
        backNavigationButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backNavigationButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backNavigationButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        restoreNavigationButton.setTitle("paywall_restore".localize(), for: .normal)
        restoreNavigationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        restoreNavigationButton.setTitleColor(UIColor.NewSubs.dark, for: .normal)
        restoreNavigationButton.frame = CGRect(x: 0, y: 0, width: 120, height: 24)
        restoreNavigationButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        let restoreBarButtonItem = UIBarButtonItem(customView: restoreNavigationButton)
        navigationItem.rightBarButtonItem = restoreBarButtonItem
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
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
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.36)
        
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
            make.height.equalTo(screenHeight * 0.38)
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
                
                let formattedOldPrice = PurchaseManager.shared.getOldPriceFormatted(for: storeProduct, discount: product.discount)
                
                let presentableProduct = PresentableProduct(sku: product.sku,
                                                            title: getProductName(key: storeProduct.localizedTitle),
                                                            description: getProductDescription(key: storeProduct.localizedDescription),
                                                            price: storePrice,
                                                            oldPrice: formattedOldPrice,
                                                            isSelected: product.isPromoted,
                                                            isBest: product.isBestOffer,
                                                            isDiscounted: product.discount)
                
                selectedOfferSKU = product.isPromoted ? product.sku : selectedOfferSKU
                createProduct(item: presentableProduct)
            }
            
        }
    }
    
    private func createProduct(item: PresentableProduct) {
        let productItemView = PaywallProductView()
        presentedProductViewArray.append(productItemView)
        
        productItemView.set(id: item.sku)
        productItemView.set(isDiscounted: item.isDiscounted)
        productItemView.set(newPriceText: item.price)
        
        productItemView.set(oldPriceText: item.oldPrice)
        productItemView.set(productNameText: item.title)
        productItemView.set(isSelected: item.isSelected)
        productItemView.delegate = self
        
        productStackView.addArrangedSubview(productItemView)
        
        productItemView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
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
    
    private func setSelectedItem(sku: String) {
        presentedProductViewArray.forEach { item in
            if let viewProductId = item.productID {
                item.set(isSelected: sku == viewProductId)
            }
        }
    }
    
    private func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.navigationItem.hidesBackButton = show
            self.backNavigationButton.isUserInteractionEnabled = !show
            self.restoreNavigationButton.isUserInteractionEnabled = !show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Subscription -
extension PaywallViewController {
    private func subscribeItem(productId: String) {
        if let product = getSKProduct(skuID: productId) {
            isLoading(show: true)
            PurchaseManager.shared.buy(product: product) { [weak self] success, _, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading(show: false)
                    
                    if success {
                        if let receipt = PurchaseManager.shared.appStoreReceiptStr(), let networkService = self.networkService {
                            var consumeReceiptRequest = ConsumeReceiptRequest()
                            consumeReceiptRequest.setParams(receipt: receipt, code: self.appliedCouponCode)
                            
                            networkService.request(consumeReceiptRequest) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let response):
                                        if response.success {
                                            print("💙: subscription - success")
                                            self.subscriptionOperationSucceeded(userInfo: response.user)
                                        } else {
                                            print("💙: subscription - error4")
                                            self.showRestoreFailedAlert()
                                            Analytics.logEvent("SubscriptionErrorBackend", parameters: [:])
                                        }
                                    case .failure:
                                        print("💙: subscription - error5")
                                        self.showRestoreFailedAlert()
                                        Analytics.logEvent("SubscriptionErrorBackend1", parameters: [:])
                                    }
                                }
                            }
                        } else {
                            print("💙: subscription - error6")
                            self.showRestoreFailedAlert()
                            Analytics.logEvent("SubscriptionErrorApple", parameters: [:])
                        }
                    } else if error == .paymentWasCancelled {
                        print("💙: subscription - error7")
                        Analytics.logEvent("SubscriptionErrorCancel", parameters: [:])
                    } else {
                        print("💙: subscription - error8")
                        Analytics.logEvent("SubscriptionErrorUnknown", parameters: [:])
                    }
                }
            }
        } else {
            print("💙: subscription - error9")
            Analytics.logEvent("SubscriptionErrorProduct", parameters: [:])
        }
    }
    
    private func subscriptionOperationSucceeded(userInfo: User) {
        DispatchQueue.main.async {
            SettingsManager.shared.settings?.user.isSubscribed = userInfo.isSubscribed
            NotificationCenter.default.post(name: NSNotification.Name.subscriptionStateUpdated, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func restoreSubscription() {
        isLoading(show: true)
        PurchaseManager.shared.restorePurchases { [weak self] success, _, _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading(show: false)
                
                if success, let receipt = PurchaseManager.shared.appStoreReceiptStr(), let networkService = self.networkService {
                    var consumeReceiptRequest = ConsumeReceiptRequest()
                    consumeReceiptRequest.setParams(receipt: receipt)
                    
                    networkService.request(consumeReceiptRequest) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let response):
                                if response.success {
                                    print("💙: restore - success")
                                    self.subscriptionOperationSucceeded(userInfo: response.user)
                                } else {
                                    self.showRestoreFailedAlert()
                                }
                            case .failure:
                                self.showRestoreFailedAlert()
                            }
                        }
                    }
                } else {
                    self.showRestoreFailedAlert()
                }
            }
        }
    }
    
}

// MARK: - Coupon -
extension PaywallViewController {
    
    private func processCouponCode(_ code: String) {
        guard let networkService = networkService else { return }
        var applyCouponRequest = ApplyCouponRequest()
        applyCouponRequest.setParams(code: code)
        isLoading(show: true)
        networkService.request(applyCouponRequest) { result in
            DispatchQueue.main.async {
                self.isLoading(show: false)
                switch result {
                case .success(let response):
                    self.presentableProducts = response.products
                    self.setProducts()
                    self.checkThenSetCouponLabel()
                    self.appliedCouponCode = code
                case .failure(let error):
                    let errorMessage = ErrorHandler.getErrorMessage(for: error)
                    Toaster.showToast(message: errorMessage)
                    self.appliedCouponCode = nil
                    Analytics.logEvent("032APIApplyCouponRequest", parameters: ["error" : errorMessage])
                }
            }
        }
    }
    
    private func showCouponAlert() {
        let alertController = UIAlertController(title: "enter_coupon_code".localize(), message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "coupon_code_placeholder".localize()
            textField.clearButtonMode = .whileEditing
        }
        
        let tryAction = UIAlertAction(title: "coupon_alert_try".localize(), style: .default) { [weak self, weak alertController] _ in
            if let code = alertController?.textFields?.first?.text {
                self?.processCouponCode(code)
            }
        }
        
        let cancelAction = UIAlertAction(title: "coupon_alert_cancel".localize(), style: .cancel, handler: nil)
        
        alertController.addAction(tryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - gesture recognizers - flows
extension PaywallViewController {
    private func showRestoreFailedAlert() { //TODO: restore ile normal fail ayır
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "error_on_restore_title".localize(),
                                                    message: "error_on_restore_desc".localize(),
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showSubscriptionTerms() {
        let tosDefaultUrl = SettingsManager.shared.settings?.links.termsURL ?? Constants.appTermsOfServicePageURLString
        guard let url = URL(string: tosDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        showCouponAlert()
    }

    @objc private func restoreButtonTapped() {
        restoreSubscription()
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        if let selectedSKU = selectedOfferSKU,
           let product = presentableProducts.first(where: { $0.sku == selectedSKU }) {
            subscribeItem(productId: product.sku)
        } else {
            Toaster.showToast(message: "error_try_again".localize())
        }
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


extension PaywallViewController: PaywallProductViewDelegate {
    func productSelected(id: String?) {
        guard let sku = id else { return }
        selectedOfferSKU = sku
        setSelectedItem(sku: sku)
    }
    
}

// MARK: - To activate default swipe back gesture again
extension PaywallViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
