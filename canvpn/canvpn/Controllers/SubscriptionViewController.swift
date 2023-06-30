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
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        products = PurchaseManager.shared.products
        
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
    
    private func showSubscriptionTerms() {
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func mockPurchaseStart() {
        
        
        
        
    }
    
    private func restoreSubscription() {
        goPreView.isLoading(show: true)
        PurchaseManager.shared.restorePurchases { success, productIds, error in
            if success {
                if let receipt = PurchaseManager.shared.appStoreReceiptStr(), let networkService = self.networkService {
                    var consumeReceiptRequest = ConsumeReceiptRequest()
                    consumeReceiptRequest.setParams(receipt: receipt)
                    networkService.request(consumeReceiptRequest) { result in
                        switch result {
                        case .success(let response):
                            if response.success {
                                print("💙: restore - success")
                            } else {
                                self.showRestoreFailedAlert()
                            }
                        case .failure(let error):
                            self.showRestoreFailedAlert()
                        }
                    }
                } else {
                    self.goPreView.isLoading(show: false)
                    self.showRestoreFailedAlert()
                }
            }
        }
    }
    
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
    
    private func showAlert123() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "MOCK",
                                                    message: "dummy item",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
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
                        if let receipt = PurchaseManager.shared.appStoreReceiptStr(), let networkService = self.networkService {
                            var consumeReceiptRequest = ConsumeReceiptRequest()
                            consumeReceiptRequest.setParams(receipt: receipt)
                            
                            networkService.request(consumeReceiptRequest) { result in
                                switch result {
                                case .success(let response):
                                    if response.success {
                                        print("💙: subscription - success")
                                    } else {
                                        self.showRestoreFailedAlert()
                                    }
                                case .failure(let error):
                                    self.showRestoreFailedAlert()
                                }
                                DispatchQueue.main.async {
                                    self.goPreView.isLoading(show: false)
                                }
                            }
                        } else {
                            self.showRestoreFailedAlert()
                        }
                    } else if error == .paymentWasCancelled {
                        DispatchQueue.main.async {
                            self.goPreView.isLoading(show: false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.goPreView.isLoading(show: false)
                        }
                    }
                }
            }
        }
    }
    
}

extension SubscriptionViewController: PremiumViewDelegate {
    func subscriptionTermsTapped() {
        showSubscriptionTerms()
    }
    
    func subscriptionRestoreTapped() {
        restoreSubscription()
    }
    
    func subscribeSelected(indexOf: Int) {
//
//        let mockProductID = "com.arbtech.ilovevpn.ios.weekly"
//        subscribeItem(productId: mockProductID)
//
//
        if checkProductIsSafe(index: indexOf) {
         //   subscribeItem(productId: "")
            if let skuID = SettingsManager.shared.settings?.products[indexOf].sku {
                subscribeItem(productId: skuID)
            } else {
                showAlert123()
            }
        } else {
            showAlert123()
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
