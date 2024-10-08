//
//  TimerOfferViewController.swift
//  canvpn
//
//  Created by Can Babaoğlu on 16.09.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

class TimerOfferViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    var countdownTimer: Timer!
    var remainingSeconds: Int = 0 {
        didSet {
            countdownLabel.text = formatTimeString(seconds: remainingSeconds)
        }
    }
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "back-offer-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var backGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.gradientLayer.colors = [
            UIColor.NewSubs.orange.cgColor,
            UIColor.NewSubs.orangish.cgColor
        ]
        return gradientView
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discount-top-img")
        imageView.contentMode = .bottom
        return imageView
    }()
    
    private lazy var topCenterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "discount-center-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NewSubs.orange
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor.NewSubs.dark
        label.textAlignment = .center
        label.text = "timer_offer_title".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var getButton: NewOfferButton = {
        let view = NewOfferButton(type: .system)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getButtonTapped(_:))))
        view.textLabel.text = "timer_offer_button".localize()
        view.setOrangeUI()
        return view
    }()
    
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        label.textColor = .white
        label.layer.applySketchShadow()
        label.text = "       "
        return label
    }()
    
    private lazy var cdBackGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.layer.cornerRadius = 10.0
        gradientView.gradientLayer.cornerRadius = 10.0
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.gradientLayer.colors = [
            UIColor.NewSubs.cdOrange.cgColor,
            UIColor.NewSubs.orange.cgColor
        ]
        return gradientView
    }()
    
    private lazy var socialProof1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "social-proof-apple-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var socialProof2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "social-proof-liked-img")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    private lazy var lineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vertical-line")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var securedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.NewSubs.gray
        label.textAlignment = .center
        label.text = "secured_offer_text".localize()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var productView: NewProductView = {
        let view = NewProductView()
        view.setOrangeUI()
        return view
    }()
    
    private var networkService: DefaultNetworkService?
    
    private var products: [SKProduct]?
    private var offerProduct: Offer? = nil
    
    override func viewDidLoad() {
        Analytics.logEvent("DisconnectOfferPresented", parameters: [:])
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        securedLabel.isHidden = (SettingsManager.shared.settings?.isInReview ?? true )
        configureUI()
        setProduct()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGestureRecognizer()
        activateCloseButtonTimer()
        let countdown = Int.random(in: 70...125)
        startCountdown(from: countdown)
    }
    
    private func setGestureRecognizer() {
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped(_:)))
        termsLabel.addGestureRecognizer(termsTapGesture)
        termsLabel.isUserInteractionEnabled = true
        
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped(_:)))
        privacyLabel.addGestureRecognizer(privacyTapGesture)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(topBackView)
        topBackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(240) // bottom inset fixed!!
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // MARK: - scrollable
        contentView.addSubview(backGradientView)
        backGradientView.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.height.equalTo(240)
        }
        
        contentView.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.bottom.equalTo(backGradientView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(topCenterImageView)
        topCenterImageView.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backGradientView.snp.bottom).offset(64)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(topCenterImageView.snp.bottom).offset(20)
        }
        
        contentView.addSubview(cdBackGradientView)
        cdBackGradientView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(180)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        contentView.addSubview(countdownLabel)
        countdownLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cdBackGradientView.snp.centerY)
        }
        
        let stackView2 = UIStackView(arrangedSubviews: [socialProof1, socialProof2])
        stackView2.axis = .horizontal
        stackView2.alignment = .center
        stackView2.distribution = .fillProportionally
        stackView2.spacing = 16
        
        contentView.addSubview(stackView2)
        stackView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(countdownLabel.snp.bottom).offset(40)
            make.bottom.equalToSuperview().inset(20) // Ensures that contentView expands dynamically
        }
        
        // Fixed bottom views
        view.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(65)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
        
        getButton.layer.applySketchShadow()
        
        view.addSubview(securedLabel)
        securedLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(getButton.snp.top).inset(-4)
        }
        
        view.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(93)
            make.bottom.equalTo(getButton.snp.top).inset(-30)
        }
        
        let stackView = UIStackView(arrangedSubviews: [termsLabel, privacyLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(getButton.snp.bottom).offset(20)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(2)
        }
        
        // Add the close button
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(24)
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
        }
        
        configureActivityIndicatorUI()
    }
    
    private func configureActivityIndicatorUI() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        showCloseAlert()
    }
    
    @objc private func getButtonTapped(_ sender: UIButton) {
        subscribeOffer()
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
            Analytics.logEvent("SpecialOfferSubsTappedFromAlert", parameters: [:])
            self.subscribeOffer()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(tryNowAction)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tryNowAction.setValue(UIColor.green, forKey: "titleTextColor")

        present(alertController, animated: true)
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
    
    private func activateCloseButtonTimer() {
        if SettingsManager.shared.settings?.isInReview == true {
            self.closeButton.isUserInteractionEnabled = true
            self.closeButton.alpha = 1
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.closeButton.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.5) {
                    self?.closeButton.alpha = 1
                }
            }
        }
    }
    
    func formatTimeString(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d : %02d", minutes, seconds)
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
        }
    }
    
    // MARK: - Subscription -
    
    private func getSKProduct(skuID: String) -> SKProduct? {
        return products?.first(where: { $0.productIdentifier == skuID})
    }
    
    private func setProduct() {
        products = PurchaseManager.shared.products
        offerProduct = SettingsManager.shared.settings?.disconnectOffer
        
        guard let offerProduct = offerProduct,
              let storeProduct = getSKProduct(skuID: offerProduct.sku),
              let storePrice = PurchaseManager.shared.getPriceFormatted(for: storeProduct) else {
            return }
        
        let formattedOldPrice = PurchaseManager.shared.getOldPriceFormatted(for: storeProduct, discount: offerProduct.discount)
        
        productView.set(productNameText: getProductName(key: storeProduct.localizedTitle))
        productView.set(oldPriceText: formattedOldPrice)
        productView.set(newPriceText: storePrice)
        productView.set(discountText: "% \(offerProduct.discount)")
    }
    
    private func getProductName(key: String) -> String {
        guard SettingsManager.shared.settings?.isInReview == false else { return key }
        return key.localize()
    }
    
    private func subscribeOffer() {
        guard let offerProduct = offerProduct else { return }
        subscribeItem(productId: offerProduct.sku)
    }
    
    private func subscribeItem(productId: String) {
        Analytics.logEvent("SpecialOfferSubsItem", parameters: [:])
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
                                            Analytics.logEvent("SpecialOfferErrorBackend", parameters: [:])
                                        }
                                    case .failure:
                                        print("💙: subscription - error5")
                                        self.showRestoreFailedAlert()
                                        Analytics.logEvent("SpecialOfferErrorBackend1", parameters: [:])
                                    }
                                }
                            }
                        } else {
                            print("💙: subscription - error6")
                            self.showRestoreFailedAlert()
                            Analytics.logEvent("SpecialOfferErrorApple", parameters: [:])
                        }
                    } else if error == .paymentWasCancelled {
                        print("💙: subscription - error7")
                        Analytics.logEvent("SpecialOfferErrorCancel", parameters: [:])
                    } else {
                        print("💙: subscription - error8")
                        Analytics.logEvent("SpecialOfferErrorUnknown", parameters: [:])
                    }
                }
            }
        } else {
            print("💙: subscription - error9")
            Analytics.logEvent("SpecialOfferErrorProduct", parameters: [:])
        }
    }
    
    private func isLoading(show: Bool) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = !show
            self.closeButton.isHidden = show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    private func subscriptionOperationSucceeded(userInfo: User) {
        DispatchQueue.main.async {
            SettingsManager.shared.settings?.user.isSubscribed = userInfo.isSubscribed
            NotificationCenter.default.post(name: NSNotification.Name.subscriptionStateUpdated, object: nil)
            self.dismiss(animated: true)
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
}
