//
//  SpecialOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.04.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class SpecialOfferViewController: UIViewController {
    
    var countdownTimer: Timer!
    var remainingSeconds: Int = 0 {
        didSet {
            countdownLabel.text = formatTimeString(seconds: remainingSeconds)
        }
    }
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.text = "special_offer_title".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "offer-img-girl")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "special_offer_discount_text".localize()
        return label
    }()
    
    private lazy var badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "must-have-badge")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var reviewCarouselImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "review-carousel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        label.textColor = .orange
        label.layer.applySketchShadow()
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var getButton: LandingButton = {
        let view = LandingButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "special_offer_button".localize()
        return view
    }()
    
    private lazy var termsLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .left
        label.text = "terms_of_service_key".localize()
        return label
    }()
    
    private lazy var privacyLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.Subscription.orangeText
        label.textAlignment = .right
        label.text = "privacy_policy_key".localize()
        return label
    }()
    
    private lazy var offerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.Subscription.titleText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "bordered-close-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var presentableProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setGestureRecognizer()
        activateCloseButtonTimer()
        startCountdown(from: 109)
        offerLabel.text = "offer_info_text_before".localize() + " " + "€ 1,99" + " " + "offer_info_text_duration".localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("023SpecialOfferPresented", parameters: ["type" : "willAppear"])
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    private func configureUI() {
        view.addSubview(backGradientView)
        view.addSubview(titleLabel)
        view.addSubview(backgroundImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(badgeImageView)
        view.addSubview(reviewCarouselImageView)
        view.addSubview(countdownLabel)
        view.addSubview(getButton)
        view.addSubview(offerLabel)
        view.addSubview(termsLabel)
        view.addSubview(privacyLabel)
        view.addSubview(closeButton)
        
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel).offset(-8)
            make.height.equalToSuperview().dividedBy(2.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().inset(48)
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(48)
            make.height.equalToSuperview().dividedBy(13)
        }
        
        reviewCarouselImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.width.equalToSuperview()
        }
        
        countdownLabel.snp.makeConstraints { make in
            make.bottom.equalTo(getButton.snp.top).inset(-48)
            make.centerX.equalToSuperview()
        }
        
        getButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
        offerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(getButton.snp.top).offset(-10)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(12)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(12)
        }

        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
        
        configureActivityIndicatorUI()
    }

    private func configureActivityIndicatorUI() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func activateCloseButtonTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.closeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self?.closeButton.alpha = 1
            }
        }
    }
    
    func startCountdown(from seconds: Int) {
        remainingSeconds = seconds
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        } else {
            countdownTimer.invalidate()
            // Handle what happens when the timer reaches 0
        }
    }
    
    func formatTimeString(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: ACTIONS
    @objc private func getButtonTapped(_ sender: UIButton) {
        subscribeOffer()
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        showCloseAlert()
    }
    
    @objc func termsLabelTapped(_ gesture: UITapGestureRecognizer) {
        showSubscriptionTerms()
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        showPrivacyPage()
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
            self.dismiss(animated: true)
        }

        let tryNowAction = UIAlertAction(
            title: "offer_alert_try".localize(),
            style: .default
        ) { (action) in
            self.subscribeOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tryNowAction.setValue(UIColor.green, forKey: "titleTextColor")

        present(alertController, animated: true)
    }
    
    private func subscribeOffer() {
        //TODO: start subs flow
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
}

// MARK: Subscription methods
extension SpecialOfferViewController {
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
            self.dismiss(animated: true)
        }
    }
    
    private func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.closeButton.isHidden = show
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
