//
//  SubscriptionViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.03.2023.
//

import UIKit
import StoreKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = DefaultNetworkService()
        checkAndSetProducts()
        configureUI()
        setOfferTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    private func checkAndSetProducts() {
        products = PurchaseManager.shared.products
        presentableProducts = SettingsManager.shared.settings?.products ?? []
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(subscriptionView)
        subscriptionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setOfferTableView() {
        subscriptionView.offerTableView.delegate = self
        subscriptionView.offerTableView.dataSource = self
        subscriptionView.offerTableView.reloadData()
    }

    private func restoreSubscription() {
        subscriptionView.isLoading(show: true)
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
                    self.subscriptionView.isLoading(show: false)
                    self.showRestoreFailedAlert()
                }
            }
        }
    }
    
    // TODO: weak selfleri ekle
    private func subscribeItem(productId: String) {
        guard let products = self.products else { return }
        
        // TODO: daha iyi bi kontrol yapılabilir
        for product in products {
            if product.productIdentifier == productId {
                subscriptionView.isLoading(show: true)
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
                                    self.subscriptionView.isLoading(show: false)
                                }
                            }
                        } else {
                            self.showRestoreFailedAlert()
                        }
                    } else if error == .paymentWasCancelled {
                        DispatchQueue.main.async {
                            self.subscriptionView.isLoading(show: false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.subscriptionView.isLoading(show: false)
                        }
                    }
                }
            } else {
                // TODO: hiç product bulunamamsı
            }
        }
    }
    
    private func selectGivenOffer(indexPath: IndexPath) {
        subscriptionView.offerTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        selectedOfferIndex = indexPath.row
    }
    
}

// MARK: - PremiumViewDelegate
extension SubscriptionViewController: PremiumViewDelegate {
    func subscribeTapped() {
        if let index = selectedOfferIndex, let skuID = SettingsManager.shared.settings?.products[index].sku {
            subscribeItem(productId: skuID)
        } else {
            showAlert123()
        }
    }
    func subscriptionTermsTapped() {
        showSubscriptionTerms()
    }
    func subscriptionRestoreTapped() {
        restoreSubscription()
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
        cellData.isPromoted ? selectGivenOffer(indexPath: indexPath) : ()

        cell.setName(text: cellData.sku)
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
    
    private func showSubscriptionTerms() {
        let alertController = UIAlertController(title: "subs_terms_key".localize(),
                                                message: "subs_terms_detail_key".localize(),
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok_button_key".localize(), style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
