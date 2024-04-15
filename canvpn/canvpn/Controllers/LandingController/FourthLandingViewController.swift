//
//  FourthLandingViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 11.04.2024.
//

import UIKit
import StoreKit

protocol FourthLandingDelegate: AnyObject {
    func goNextFromFourth()
}

class FourthLandingViewController: UIViewController {
    
    public weak var delegate: FourthLandingDelegate?
    
    private lazy var landingView = LandingMainView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        landingView.delegate = self
        configureUI()
        landingView.configureAsOfferView()
        activateCloseButtonTimer()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(landingView)
        landingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func set(data: LandingData) {
        landingView.setStep(image: data.stepImage)
        landingView.setCenterImage(image: data.centerImage)
        landingView.setTitle(text: data.title)
        landingView.setDescription(text: data.description)
        landingView.setButonText(text: data.butonText)
    }
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.landingView.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.landingView.closeButton.alpha = 1
            }
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
    
    private func showPrivacyPage() {
        let ppDefaultUrl = SettingsManager.shared.settings?.links.privacyURL ?? Constants.appPrivacyPolicyPageURLString
        guard let url = URL(string: ppDefaultUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showCloseAlert() {
        let alertController = UIAlertController(
            title: "offer_alert_title".localize(),
            message: "offer_alert_message".localize(),
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: "offer_alert_cancel".localize(),
            style: .default
        ) { (action) in
            self.delegate?.goNextFromFourth()
        }

        let tryNowAction = UIAlertAction(
            title: "offer_alert_try".localize(),
            style: .default
        ) { (action) in
            self.subscribeInitialOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tryNowAction.setValue(UIColor.green, forKey: "titleTextColor")

        present(alertController, animated: true)
    }
    
    private func subscribeInitialOffer() {
        //TODO: start subs flow
    }
    
}

extension FourthLandingViewController: LandingMainViewDelegate {
    func closeTapped() {
        showCloseAlert()
    }
    
    func termsTapped() {
        showSubscriptionTerms()
    }
    
    func privacyTapped() {
        showPrivacyPage()
    }
    
    func nextTapped() {
        subscribeInitialOffer()
    }
}

// MARK: Subscription methods
extension FourthLandingViewController {
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
    
    private func subscriptionOperationSucceeded(userInfo: User) {
        DispatchQueue.main.async {
            SettingsManager.shared.settings?.user.isSubscribed = userInfo.isSubscribed
            NotificationCenter.default.post(name: NSNotification.Name.subscriptionStateUpdated, object: nil)
            self.delegate?.goNextFromFourth()
        }
    }
    
    private func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.landingView.closeButton.isHidden = show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    private func getProductName(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
    
    private func getProductDescription(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
    
    private func checkAndSetProducts() {
        products = PurchaseManager.shared.products
        // TODO: burada yeni id den geleni yapaccağız
        presentableProducts = SettingsManager.shared.settings?.products ?? []
        setProducts()
    }
    
    private func setProducts() {
        presentableProducts.forEach { product in
            if let storeProduct = getSKProduct(skuID: product.sku), let storePrice = PurchaseManager.shared.getPriceFormatted(for: storeProduct) {
                
                let presentableProduct = PresentableProduct(sku: product.sku,
                                                            title: getProductName(key: storeProduct.localizedTitle),
                                                            description: getProductDescription(key: storeProduct.localizedDescription),
                                                            price: storePrice,
                                                            isSelected: product.isPromoted,
                                                            isBest: product.isBestOffer,
                                                            isDiscounted: product.discount)
                
                // TODO: gelen product datalarından gerekliyi ekrana set et
            }
        }
    }
    
    private func getSKProduct(skuID: String) -> SKProduct? {
        return products?.first(where: { $0.productIdentifier == skuID})
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
                            consumeReceiptRequest.setParams(receipt: receipt, code: nil)
                            
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
    
}
