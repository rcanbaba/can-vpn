//
//  SubscriptionViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class SubscriptionViewController: ScrollableViewController {
    
    // MARK: UI Components
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var subscriptionView =  SubscriptionView()
    private lazy var subscriptionOverlay =  SubscriptionOverlayView()
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    
    private var selectedOfferSKU: String?
    private var appliedCouponCode: String?
    
    private var premiumFeatures: [PremiumFeatureType] = [.secure, .fast, .noAds, .anonymous, .fast]
    
    private var reviews: [ReviewItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        checkAndSetProducts()
        configureUI()
        configureOverlayUI()
        configureActivityIndicatorUI()
        setNavigationButton()
        setFeaturesTableView()
        checkThenSetCouponLabel()
        createReviews()
        
        // Remova TODO::
        setProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("006-SubsScreenPresented", parameters: ["type" : "willAppear"])
        setNavigationBar()
        appliedCouponCode = nil
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureUI() {
        configureMainUI()
        configureOverlayUI()
        configureActivityIndicatorUI()
    }
    
    private func setProducts() {
        subscriptionOverlay.createProduct(id: "123", title: "Monthly", description: "Unlimited access - 99.99 tl / Month", isSelected: true, isBest: false, isDiscounted: 0)
        subscriptionOverlay.createProduct(id: "124", title: "6 Month", description: "Unlimited access - 599.99 tl / Month", isSelected: false,
                                          isBest: false, isDiscounted: 0)
        subscriptionOverlay.createProduct(id: "125", title: "Annual", description: "Unlimited access - 1299.99 tl", isSelected: false, isBest: true, isDiscounted: 0)
    }
    
    private func checkAndSetProducts() {
        products = PurchaseManager.shared.products
        presentableProducts = SettingsManager.shared.settings?.products ?? []
    }
    
    private func checkThenSetCouponLabel() {
        let showCoupon = SettingsManager.shared.settings?.interface.showCoupon ?? false
        subscriptionOverlay.setCouponButton(isHidden: !showCoupon)
        // TODO: remove below
        subscriptionOverlay.setCouponButton(isHidden: false)
    }
    
    private func configureMainUI() {
        baseView.addSubview(subscriptionView)
        subscriptionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.insertSubview(backGradientView, at: 0)
        backGradientView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureOverlayUI() {
        view.addSubview(subscriptionOverlay)
        subscriptionOverlay.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        subscriptionOverlay.layer.applySubscriptionShadow(y: -1)
        subscriptionOverlay.layer.cornerRadius = 12.0
        subscriptionOverlay.delegate = self
    }
    
    private func configureActivityIndicatorUI() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setNavigationButton() {
        let historyButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let historyImage = UIImage(systemName: "clock.arrow.circlepath", withConfiguration: configuration)?.withTintColor(UIColor.Custom.goPreButtonGold, renderingMode: .alwaysOriginal)
        historyButton.setImage(historyImage, for: .normal)
        historyButton.addTarget(self, action: #selector(presentSubscriptionHistory), for: .touchUpInside)
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.orange
    }
    
    private func setFeaturesTableView() {
        subscriptionView.featuresTableView.delegate = self
        subscriptionView.featuresTableView.dataSource = self
        subscriptionView.featuresTableView.reloadData()
    }
    
    public func isLoading(show: Bool) { // TODO: TEST it
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.navigationItem.hidesBackButton = show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
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
                                        }
                                    case .failure:
                                        print("💙: subscription - error5")
                                        self.showRestoreFailedAlert()
                                    }
                                }
                            }
                        } else {
                            print("💙: subscription - error6")
                            self.showRestoreFailedAlert()
                        }
                    } else if error == .paymentWasCancelled {
                        print("💙: subscription - error7")
                        // Handle payment cancellation
                    } else {
                        print("💙: subscription - error8")
                        // Handle other errors
                    }
                }
            }
        } else {
            print("💙: subscription - error9")
            // Handle case when product is not found backendden gelmiş apple da yok
        }
    }
    
    private func selectGivenOffer(indexPath: IndexPath) {
        // TODO: set selection
//        subscriptionView.offerTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        selectedOfferSKU = presentableProducts[indexPath.row].sku
    }
    
    private func getSKProduct(skuID: String) -> SKProduct? {
        return products?.first(where: { $0.productIdentifier == skuID})
    }
    
    private func subscriptionOperationSucceeded(userInfo: User) {
        DispatchQueue.main.async {
            SettingsManager.shared.settings?.user.isSubscribed = userInfo.isSubscribed
            NotificationCenter.default.post(name: NSNotification.Name.subscriptionStateUpdated, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func presentSubscriptionHistory() {
        let viewController = SubscriptionHistoryViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func getCellName(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
    
    private func getCellDescription(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SubscriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return premiumFeatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == subscriptionView.offerTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as! OfferTableViewCell
//            let cellData = presentableProducts[indexPath.row]
//            
//            if let skProduct = getSKProduct(skuID: cellData.sku), let skPrice = PurchaseManager.shared.getPriceFormatted(for: skProduct) {
//                cell.setName(text: getCellName(key: skProduct.localizedTitle))
//                cell.setPrice(text: skPrice)
//                cell.setDescription(text: getCellDescription(key: skProduct.localizedDescription))
//                cellData.isPromoted ? selectGivenOffer(indexPath: indexPath) : ()
//                cellData.isBestOffer ? cell.showBestTag() : ()
//                cellData.discount != 0 ? cell.showDiscountTag(percentage: cellData.discount) : ()
//            } else {
//                cell.setName(text: "unknown_product_title".localize())
//                cell.setPrice(text: "-")
//                cell.setDescription(text: "...")
//            }
//            return cell
//            
//        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturesTableViewCell", for: indexPath) as! FeaturesTableViewCell
        let cellData = premiumFeatures[indexPath.row]
        cell.set(type: cellData)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: select
//        if tableView == subscriptionView.offerTableView {
//            if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
//                for selectedIndexPath in selectedIndexPaths {
//                    tableView.deselectRow(at: selectedIndexPath, animated: false)
//                }
//            }
//            selectedOfferSKU = presentableProducts[indexPath.row].sku
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//        }
    }
}


// MARK: - Alerts
extension SubscriptionViewController {
    private func showRestoreFailedAlert() {
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
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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

// MARK: - TryCouponCode
extension SubscriptionViewController {
    private func tryCouponCode() {
        showCouponAlert()
    }
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
                  //  self.setOfferTableView()
                    self.checkThenSetCouponLabel()
                    self.appliedCouponCode = code
                case .failure(let error):
                    let errorMessage = ErrorHandler.getErrorMessage(for: error)
                    Toaster.showToast(message: errorMessage)
                    self.appliedCouponCode = nil
                    Analytics.logEvent("032-API-ApplyCouponRequest", parameters: ["error" : errorMessage])
                }
            }
        }
    }
}

// MARK: - SubscriptionOverlayViewDelegate
extension SubscriptionViewController: SubscriptionOverlayViewDelegate {
    func subscriptionTermsTapped() {
        showSubscriptionTerms()
    }
    func subscriptionRestoreTapped() {
        restoreSubscription()
    }
    func tryCouponCodeTapped() {
        tryCouponCode()
    }
    func subscribeTapped() {
        print("TODO123123: subscribeTapped")
        //        if let selectedSKU = selectedOfferSKU,
        //           let product = presentableProducts.first(where: { $0.sku == selectedSKU }) {
        //            subscribeItem(productId: product.sku)
        //        } else {
        //            Toaster.showToast(message: "error_try_again".localize())
        //        }
    }
    func productSelected(id: String?) {
        print("TODO123123: productSelected")
    }
}

// MARK: - Reviews
extension SubscriptionViewController {
    private func createReviews() {
        reviews = ReviewItemGenerator.getRandomReviews()
        subscriptionView.createReviews(dataArray: reviews)
    }
}

// MARK: - Public Methods
extension SubscriptionViewController {
    public func restoreSubscriptionFromOutside() {
        restoreSubscription()
    }
    
    public func presentSubscriptionHistoryFromOutside() {
        presentSubscriptionHistory()
    }
    
    public func usePromoCodeFromOutside() {
        tryCouponCode()
    }
}
