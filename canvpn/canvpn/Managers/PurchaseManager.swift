//
//  PurchaseManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 22.06.2023.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject {
    
    // MARK: - Custom Types
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
    
    // MARK: - Properties
    static let shared = PurchaseManager()
    
    public typealias ProductsRequestCompletionHandler = (_ success: Bool,
                                                         _ products: [SKProduct]?,
                                                         _ invalidIds: [String]?,
                                                         _ error: IAPManagerError?) -> Void
    public typealias ProductPurchaseCompletionHandler = (_ success: Bool,
                                                         _ productIds: String?,
                                                         _ error: IAPManagerError?) -> Void
    
    private var totalRestoredPurchases = 0
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
    
    public var products: [SKProduct]?
    public var savedPayment: SKPayment?
    
    // MARK: - Init
    private override init() {
        super.init()
    }
    
    // MARK: - General Methods
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    func getPriceMonthlyOfAnnual(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 2
        return formatter.string(from: product.price.dividing(by: 12))
    }
    
    func getPriceWeeklyOfAnnual(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 2
        return formatter.string(from: product.price.dividing(by: 52))
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }

    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // MARK: - Get IAP Products
    func getProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequestCompletionHandler = completionHandler
        var productIds = SettingsManager.shared.settings?.skus ?? []
        productIds.append("com.ilovevpn.1month_vip")
        if !productIds.isEmpty {
            let productIdentifiers = Set<String>(productIds)
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            completionHandler(false, nil, nil, nil)
        }
    }
    
    // MARK: - Purchase Products
    func buy(product: SKProduct, _ completionHandler: @escaping ProductPurchaseCompletionHandler) {
        productPurchaseCompletionHandler = completionHandler
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(_ completionHandler: @escaping ProductPurchaseCompletionHandler) {
        productPurchaseCompletionHandler = completionHandler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func appStoreReceiptStr() -> String? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data.base64EncodedString()
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func continuePayment(_ completionHandler: @escaping ProductPurchaseCompletionHandler) {
        guard let savedPayment = savedPayment else { return }
        productPurchaseCompletionHandler = completionHandler
        SKPaymentQueue.default().add(savedPayment)
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchaseManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                productPurchaseCompleted(identifier: transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                productPurchaseFailed(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            // receipt
//            NotificationCenter.default.post(name: .restoreSuccessful, object: nil)
            productPurchaseCompletionHandler?(true, nil, nil)
        } else {
            print("IAP: No purchases to restore!")
//            NotificationCenter.default.post(name: .restoreWithoutPurchase, object: nil)
            productPurchaseCompletionHandler?(false, nil, nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                print("IAP Restore Error:", error.localizedDescription)
                productPurchaseCompletionHandler?(false, nil, IAPManagerError.noProductsFound)
            } else {
                productPurchaseCompletionHandler?(false, nil, IAPManagerError.paymentWasCancelled)
            }
        }
//        NotificationCenter.default.post(name: .operationFailed, object: nil)
    }
    
    private func productPurchaseFailed(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError {
            if error.code != .paymentCancelled {
                productPurchaseCompletionHandler?(false, nil, IAPManagerError.noProductsFound)
            } else {
                productPurchaseCompletionHandler?(false, nil, IAPManagerError.paymentWasCancelled)
            }
            print("IAP Error:", error.localizedDescription)
        }
//        NotificationCenter.default.post(name: .operationFailed, object: nil)
    }
    
    private func productPurchaseCompleted(identifier: String) {
        productPurchaseCompletionHandler?(true, identifier, nil)
//        NotificationCenter.default.post(name: .purchaseSuccessful, object: identifier)
    }
    
}

// MARK: - SKProductsRequestDelegate
extension PurchaseManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Get the available products contained in the response.
        let products = response.products
        let invalidIds = response.invalidProductIdentifiers
        let success = true
        if products.count > 0 {
            self.products = products
            productsRequestCompletionHandler?(success, products, invalidIds, nil)
        } else {
            // No products were found.
            productsRequestCompletionHandler?(success, nil, invalidIds, IAPManagerError.noProductsFound)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil, nil, IAPManagerError.productRequestFailed)
//        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    func requestDidFinish(_ request: SKRequest) {
        // Implement this method OPTIONALLY and add any custom logic
        // you want to apply when a product request is finished.
    }
    
}

// MARK: - IAPManagerError Localized Error Descriptions
extension PurchaseManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "error_on_productId".localize()
        case .noProductsFound: return "error_on_product".localize()
        case .productRequestFailed: return "error_on_product_request".localize()
        case .paymentWasCancelled: return "error_on_payment".localize()
        }
    }
}
