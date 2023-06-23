//
//  SubscriptionViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    private lazy var goPreView: GoPremiumView = {
        let view = GoPremiumView()
        view.delegate = self
        return view
    }()
    
    private var products: [SKProduct]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(goPreView)
        goPreView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func mockPurchaseStart() {
        
        
        
        
    }
    
    private func restoreSubscription() {
        goPreView.isLoading(show: true)
        PurchaseManager.shared.restorePurchases { success, productIds, error in
            if success {
                if let receipt = PurchaseManager.shared.appStoreReceiptStr() {
// TODO: api gelince
//                    API.consumeProduct(receipt: receipt) { response, error in
//
//                        self.goPreView.isLoading(show: false)
//                        if let _ = response {
//                            SettingsManager.remoteSettings?.isSubscriptionExpired = false
//                            self.moveToSplash()
//                        } else {
//                            self.showRestoreFailedAlert()
//                        }
//                    }
                }
            } else {
                self.goPreView.isLoading(show: false)
                self.showRestoreFailedAlert()
            }
        }
    }
    
    private func showRestoreFailedAlert() {
        // TODO: translation
        let alertController = UIAlertController(title: "Failed to restore subscription.",
                                                message: "You don’t have an active subscription.",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // TODO: weak selfleri ekle
    
    private func subscribeItem(productId: String) {
        guard let products = self.products else { return }
        goPreView.isLoading(show: true)
        
        // TODO: daha iyi bi kontrol yapılabilir
        for product in products {
            if product.productIdentifier == productId {
                PurchaseManager.shared.buy(product: product) { success, productIds, error in
                    if success {
                        if let receipt = PurchaseManager.shared.appStoreReceiptStr() {
                        //    KeyValueStorage.isPremium = true
                // TODO:
//                            API.consumeProduct(receipt: receipt) { response, error in
//                                self.purchaseView.toggleLoading(shouldShow: false)
//                                if response?.success == true {
//                                    SettingsManager.remoteSettings?.isSubscriptionExpired = false
//                                    self.moveToSplash()
//                                } else {
//                                    self.moveToSplash()
//                                }
//                            }
                        }
                    } else if error == .paymentWasCancelled {
                        self.goPreView.isLoading(show: true)
                        // TODO: burdan nereye gidecek !!!
                        // kapatalım ayrı case değilse bunu da uçur
                    } else {
                        self.goPreView.isLoading(show: true)
                        // TODO: burdan nereye gidecek !!!
                        // kapatalım
                    }
                }
            }
        }
    }
    
}

extension SubscriptionViewController: PremiumViewDelegate {
    func subscribeSelected(indexOf: Int) {
        if checkProductIsSafe(index: indexOf) {

        } else {
            //TODO: show error toast maybe
            return
        }
    }
}

fileprivate extension SubscriptionViewController {
    private func checkProductIsSafe(index: Int) -> Bool {
        if index < (SettingsManager.shared.settings?.products ?? []).count {
            return true
        }
        return false
    }
}
