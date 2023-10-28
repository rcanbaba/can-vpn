//
//  SubscriptionViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class SubscriptionViewController: UIViewController {
    
    private lazy var subscriptionView: SubscriptionView = {
        let view = SubscriptionView()
        view.delegate = self
        return view
    }()
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    
    private var selectedOfferIndex: Int?
    private var appliedCouponCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        checkAndSetProducts()
        configureUI()
        setNavigationButton()
        setOfferTableView()
        checkThenSetCouponLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("006-SubsScreenPresented", parameters: ["type" : "willAppear"])
        setNavigationBar()
        appliedCouponCode = nil
    }
    
    private func setNavigationBar() {
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func checkAndSetProducts() {
        products = PurchaseManager.shared.products
        presentableProducts = SettingsManager.shared.settings?.products ?? []
    }
    
    private func checkThenSetCouponLabel() {
        let showCoupon = SettingsManager.shared.settings?.interface.showCoupon ?? false
        subscriptionView.setCouponLabel(isHidden: !showCoupon)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(subscriptionView)
        subscriptionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setNavigationButton() {
        let historyButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let historyImage = UIImage(systemName: "clock.arrow.circlepath", withConfiguration: configuration)?.withTintColor(UIColor.Custom.goPreButtonGold, renderingMode: .alwaysOriginal)
        historyButton.setImage(historyImage, for: .normal)
        historyButton.addTarget(self, action: #selector(presentSubscriptionHistory), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.orange
    }
    
    private func setOfferTableView() {
        subscriptionView.offerTableView.delegate = self
        subscriptionView.offerTableView.dataSource = self
        subscriptionView.offerTableView.reloadData()
    }
    
    private func restoreSubscription() {
        subscriptionView.isLoading(show: true)
        PurchaseManager.shared.restorePurchases { [weak self] success, _, _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.subscriptionView.isLoading(show: false)
                
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
            subscriptionView.isLoading(show: true)
            PurchaseManager.shared.buy(product: product) { [weak self] success, _, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.subscriptionView.isLoading(show: false)
                    
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
        subscriptionView.offerTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        selectedOfferIndex = indexPath.row
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
}

// MARK: - PremiumViewDelegate
extension SubscriptionViewController: PremiumViewDelegate {
    func subscribeTapped() {
        if let index = selectedOfferIndex, let skuID = SettingsManager.shared.settings?.products[index].sku {
            subscribeItem(productId: skuID)
        } else {
            Toaster.showToast(message: "error_try_again".localize())
        }
    }
    func subscriptionTermsTapped() {
        showSubscriptionTerms()
    }
    func subscriptionRestoreTapped() {
        restoreSubscription()
    }
    func tryCouponCodeTapped() {
        tryCouponCode()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SubscriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentableProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as! OfferTableViewCell
        let cellData = presentableProducts[indexPath.row]
        
        if let skProduct = getSKProduct(skuID: cellData.sku), let skPrice = PurchaseManager.shared.getPriceFormatted(for: skProduct) {
            cell.setName(text: skProduct.localizedTitle)
            cell.setPrice(text: skPrice)
            cell.setDescription(text: skProduct.localizedDescription)
            cellData.isPromoted ? selectGivenOffer(indexPath: indexPath) : ()
            cellData.isBestOffer ? cell.showBestTag() : ()
            cellData.discount != 0 ? cell.showDiscountTag(percentage: cellData.discount) : ()
        } else {
            cell.setName(text: "unknown_product_title".localize())
            cell.setPrice(text: "-")
            cell.setDescription(text: "...")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            for selectedIndexPath in selectedIndexPaths {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
        }
        selectedOfferIndex = indexPath.row
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
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
        subscriptionView.isLoading(show: true)
        networkService.request(applyCouponRequest) { result in
            DispatchQueue.main.async {
                self.subscriptionView.isLoading(show: false)
                switch result {
                case .success(let response):
                    self.presentableProducts = response.products
                    self.setOfferTableView()
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
